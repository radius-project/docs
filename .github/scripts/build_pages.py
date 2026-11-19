"""Build two Hugo projects into one Pages artifact, using each project's locked tools."""

import argparse
import csv
import html
import io
import json
import os
import re
import shutil
import subprocess
import tempfile
import tomllib
from pathlib import Path
from urllib.parse import quote


def publish_default_channel(output, base_url):
    """Expose stable pages and downloads at their original, unversioned URLs."""
    latest = output / "latest"
    for source in latest.rglob("*"):
        relative = source.relative_to(latest)
        if relative.parts[0] in {"edge", "latest"} or not source.is_file():
            continue
        dest = output / relative
        dest.parent.mkdir(parents=True, exist_ok=True)
        if source.suffix != ".html" or relative == Path("404.html"):
            # A CLI fetching a Bicep file or a feed cannot follow an HTML redirect.
            shutil.copyfile(source, dest)
            continue
        route = relative.as_posix()
        if relative.name == "index.html":
            route = route.removesuffix("index.html")
        target = html.escape(f"{base_url}/latest/{quote(route)}", quote=True)
        dest.write_text(
            '<!doctype html><html lang="en"><meta charset="utf-8"><title>Radius Docs</title>'
            f'<link rel="canonical" href="{target}">'
            '<script>location.replace(document.querySelector("link[rel=canonical]").href'
            '+location.search+location.hash)</script>'
            f'<noscript><meta http-equiv="refresh" content="0; url={target}"></noscript>'
            f'<a href="{target}">Latest Radius documentation</a></html>\n', encoding="utf-8",
        )


def upgrade_legacy_docsy(config, edge, release):
    """Render a pre-migration release with the pinned theme, without rewriting the checkout."""
    module = config["module"]
    legacy = "github.com/google/docsy"
    if not any(item["path"] == legacy for item in module.get("imports", [])):
        return None

    theme = json.loads(subprocess.check_output(
        ["go", "mod", "download", "-json", "github.com/docsy/docsy/theme"], cwd=edge,
    ))
    module.setdefault("replacements", []).append(f"{legacy} -> {Path(theme['Dir']).as_posix()}")
    dependencies = edge / "node_modules"
    for package, target in (
        ("bootstrap", "assets/vendor/bootstrap"),
        ("@fortawesome/fontawesome-free", "assets/vendor/Font-Awesome"),
        ("@fortawesome/fontawesome-free/webfonts", "static/webfonts"),
    ):
        module["mounts"].append({"source": str(dependencies / package), "target": target})
    # Dart Sass resolves sibling imports on disk. Give it one physical SCSS tree,
    # while retaining the release's logo, scripts and other project assets.
    module["mounts"] = [m for m in module["mounts"] if (m["source"], m["target"]) != ("assets", "assets")]
    for asset in (release / "assets").iterdir():
        source = edge / "assets/scss" if asset.name == "scss" else asset
        module["mounts"].append({"source": str(source), "target": f"assets/{asset.name}"})
    # npm still runs the release's own Hugo; add the Sass CLI missing from its lockfile.
    return {**os.environ, "PATH": os.pathsep.join((str(dependencies / ".bin"), os.environ["PATH"]))}


def build(base_url, edge, latest, output, algolia=False):
    if output.exists() and any(output.iterdir()):
        raise ValueError(f"Use an empty output directory: {output}")
    base_url = base_url.rstrip("/")
    sources = {"edge": edge, "latest": latest}
    configs = {
        name: tomllib.loads((source / "config.toml").read_text(encoding="utf-8"))
        for name, source in sources.items()
    }
    # The release workflow stamps vMAJOR.MINOR into the release checkout.
    release = configs["latest"]["params"]["version"]
    if not re.fullmatch(r"v(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)", release):
        raise ValueError(f"Expected a vMAJOR.MINOR docs release, got {release!r}")
    configs["edge"]["params"]["chart_version"] = configs["latest"]["params"]["chart_version"]
    labels = {"edge": "edge", "latest": f"latest ({release[1:]})"}
    versions = [{"version": name, "name": labels[name], "url": f"{base_url}/{name}/"} for name in sources]
    paths = {}
    npm = shutil.which("npm.cmd") or shutil.which("npm")
    if not npm:
        raise RuntimeError("npm must be on PATH to run the branch's Hugo build")
    environments = {"edge": None, "latest": upgrade_legacy_docsy(configs["latest"], edge, latest)}

    with tempfile.TemporaryDirectory() as temp:
        for name, source in sources.items():
            config = configs[name]
            config["baseURL"] = f"{base_url}/{name}/"
            config["params"].update(version_menu=labels[name], versions=versions, version_menu_pagelinks=True)
            if not algolia:
                config["params"].get("search", {}).pop("algolia", None)
                config["params"]["offlineSearch"] = True
            if name == "latest" and not (source / "layouts" / "partials" / "docs-version-menu.html").is_file():
                # Only pre-Pages branches need these templates. Keep fixes made in newer releases.
                config["module"]["mounts"].insert(0, {
                    "source": str(edge / "layouts"),
                    "target": "layouts",
                    "files": [
                        "partials/navbar.html", "partials/docs-version-menu.html", "partials/favicons.html",
                        "shortcodes/rad-deploy.html", "shortcodes/latest.html", "shortcodes/redoc.html",
                    ],
                })
            config_file = Path(temp, f"{name}.json")
            config_file.write_text(json.dumps(config), encoding="utf-8")
            # On a cold runner Hugo writes compiler/module download notices to stdout.
            # Resolve them before asking for machine-readable CSV.
            hugo = [npm, "run", "--silent", "hugo", "--"]
            subprocess.run(
                [*hugo, "mod", "graph", "--config", str(config_file)],
                cwd=source, env=environments[name], check=True,
            )
            # Ask Hugo for the real routes (including custom slugs), rather than
            # guessing from filenames or making the reader probe the other site.
            listing = subprocess.check_output(
                [*hugo, "list", "published", "--config", str(config_file)],
                cwd=source, env=environments[name], text=True, encoding="utf-8",
            )
            paths[name] = [
                row["permalink"].removeprefix(config["baseURL"])
                for row in csv.DictReader(io.StringIO(listing))
            ]
            if "" not in paths[name]:
                raise ValueError(f"Hugo did not list a home page at {config['baseURL']}")

        for name, peer in (("edge", "latest"), ("latest", "edge")):
            config = configs[name]
            config["params"]["peer_pages"] = paths[peer]
            config_file = Path(temp, f"{name}.json")
            config_file.write_text(json.dumps(config), encoding="utf-8")
            subprocess.run(
                [npm, "run", "build", "--", "--config", str(config_file), "--destination", str(output / name)],
                cwd=sources[name], env=environments[name], check=True,
            )
            if not (output / name / "index.html").stat().st_size:
                raise ValueError(f"Missing Hugo home page for {name}")
            # Older releases contain Azure hosting configuration in content/.
            (output / name / "staticwebapp.config.json").unlink(missing_ok=True)

    publish_default_channel(output, base_url)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--algolia", action="store_true", help="use the production Algolia indices instead of local search")
    parser.add_argument("base_url")
    for arg in ("edge", "latest", "output"):
        parser.add_argument(arg, type=lambda s: Path(s).resolve())
    args = parser.parse_args()
    build(args.base_url, args.edge, args.latest, args.output, args.algolia)
