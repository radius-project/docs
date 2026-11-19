"""Select the newest stable docs branch, not the most recently pushed branch."""

import re
import subprocess
import sys
import tomllib


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
    return subprocess.check_output(["git", *args], text=True)


if __name__ == "__main__":
    refs = git("for-each-ref", "--format=%(refname:strip=3) %(objectname)", "refs/remotes/origin/v*")
    branch, sha = latest_stable(
        (line.split() for line in refs.splitlines()),
        lambda ref: tomllib.loads(git("show", f"{ref}:docs/config.toml"))["params"]["chart_version"],
    )
    print(f"latest: {branch} ({sha})", file=sys.stderr)
    print(f"branch={branch}")
    print(f"sha={sha}")
