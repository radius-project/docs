"""Select the newest stable docs branch, not the most recently pushed branch."""

import argparse
import re
import subprocess
import sys
import tomllib
from pathlib import Path


def latest_stable(branches, chart_version):
    channels = {
        tuple(map(int, name[1:].split("."))): (name, sha)
        for name, sha in branches
        if re.fullmatch(r"v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)", name)
    }
    for channel in sorted(channels, reverse=True):
        name, sha = channels[channel]
        version = chart_version(sha)
        if re.fullmatch(re.escape(name[1:]) + r"\.(0|[1-9][0-9]*)(\+[0-9A-Za-z.-]+)?", version):
            return name, sha
        # A release candidate may already have a vMAJOR.MINOR docs branch.
        if not version.startswith(name[1:] + ".") or "-" not in version:
            raise ValueError(f"{name} has unexpected chart_version {version!r}")
    raise ValueError("No stable vMAJOR.MINOR docs branch found; refusing to publish edge as latest")


def git(*args):
    return subprocess.check_output(["git", *args], encoding="utf-8")


def release_site(ref, repo=Path(".")):
    # Previously cut branches have the same Hugo project one directory deeper.
    configs = git(
        "-C", repo, "ls-tree", "-r", "--name-only", ref, "--", "config.toml", "docs/config.toml"
    ).splitlines()
    if len(configs) != 1:
        raise ValueError(f"Expected one Hugo config in {repo}@{ref}, found {configs}")
    config = tomllib.loads(git("-C", repo, "show", f"{ref}:{configs[0]}"))
    version = config["params"]["chart_version"]
    if not re.fullmatch(r"\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.+-]+)?", version):
        raise ValueError(f"Invalid chart_version in {ref}:{configs[0]}: {version!r}")
    return repo / Path(configs[0]).parent, version


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--checkout", type=Path, help="report a checked-out release's site directory and Radius tag")
    args = parser.parse_args()
    if args.checkout:
        site, version = release_site("HEAD", args.checkout)
        print(f"site_dir={site.as_posix()}")
        print(f"radius_tag=v{version}")
        sys.exit(0)

    refs = git("for-each-ref", "--format=%(refname:strip=3) %(objectname)", "refs/remotes/origin/v*")
    branch, sha = latest_stable(
        (line.split() for line in refs.splitlines()),
        lambda ref: release_site(ref)[1],
    )
    print(f"latest: {branch} ({sha})", file=sys.stderr)
    print(f"branch={branch}")
    print(f"sha={sha}")
