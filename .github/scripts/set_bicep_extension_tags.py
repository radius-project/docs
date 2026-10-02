import argparse
import json
from pathlib import Path
import re

from validate_semver import parse_version


def set_extension_tags(config_text: str, version: str) -> str:
    parsed = parse_version(version)
    if parsed is None:
        raise ValueError(f"Invalid release version: {version}")

    tag = version if parsed.group("prerelease") else f"{parsed.group('major')}.{parsed.group('minor')}"
    if re.fullmatch(r"[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}", tag) is None:
        raise ValueError(f"Release version cannot be represented as an OCI tag: {version}")

    config = json.loads(re.sub(r"(?m)^[ \t]*//[^\n]*", "", config_text))
    if not isinstance(config, dict):
        raise ValueError("Bicep configuration must be an object")
    features = config.get("experimentalFeaturesEnabled", {})
    if not isinstance(features, dict) or features.get("ociEnabled") is not True:
        raise ValueError("Production GHCR extensions require ociEnabled: true")
    extensions = config.get("extensions", {})
    if not isinstance(extensions, dict):
        raise ValueError("Bicep extensions must be an object")

    for name in ("radius", "aws"):
        repository = f"br:ghcr.io/radius-project/bicep-types-{name}"
        reference = extensions.get(name)
        pattern = re.escape(repository) + r"(?::[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}|@sha256:[a-f0-9]{64})"
        if not isinstance(reference, str) or re.fullmatch(pattern, reference) is None:
            raise ValueError(f"Expected a canonical GHCR reference for the {name} extension")
        if reference == f"{repository}:edge":
            config_text = config_text.replace(json.dumps(reference), json.dumps(f"{repository}:{tag}"))

    return config_text


def main():
    parser = argparse.ArgumentParser(description="Select release tags for the docs Bicep extensions.")
    parser.add_argument("version", help="Radius release version without the v prefix")
    args = parser.parse_args()
    path = Path("bicepconfig.json")
    try:
        updated = set_extension_tags(path.read_text(), args.version)
        path.write_text(updated)
    except (OSError, ValueError) as error:
        parser.exit(1, f"Error updating {path}: {error}\n")


if __name__ == "__main__":
    main()
