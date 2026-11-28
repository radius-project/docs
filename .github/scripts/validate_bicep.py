import os
import re
import subprocess
import concurrent.futures

num_workers = 5

# This script lives in .github/scripts, two levels below the repository root.
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# The PostgreSQL demo must not rely on a `tls` setting that the Bicep types
# don't support. Bicep reports that as a warning (exit code 0), so the
# diagnostics for this file are inspected explicitly. The demo is located from
# the repository root, so the check also applies when the validator runs from
# a subdirectory.
POSTGRESQL_DEMO = os.path.join(REPO_ROOT, "static", "samples", "demo", "app-postgresql.bicep")
TLS_DIAGNOSTIC_CODES = {"BCP036", "BCP037"}

# Matches a Bicep diagnostic such as:
#   path/to/file.bicep(12,7) : Warning BCP037: The property "tls" is not allowed ...
DIAGNOSTIC_PATTERN = re.compile(
    r"^(?P<path>.+?)\((?P<line>\d+),(?P<column>\d+)\) : "
    r"(?P<severity>\w+) (?P<code>[A-Za-z]+\d+): (?P<message>.*)$"
)
TLS_PROPERTY_PATTERN = re.compile(r'\bproperty "tls"')


def normalize_path(path):
    """Resolves a path (relative to the current directory) for comparison."""
    return os.path.normcase(os.path.realpath(path))


def find_unsupported_tls_diagnostics(bicep_file, stderr):
    """Returns the BCP036/BCP037 diagnostics naming the `tls` property of the
    PostgreSQL demo.

    A diagnostic only counts when both the compiled file and the file the
    diagnostic points at are the PostgreSQL demo, so warnings that originate in
    unrelated files imported by the demo are ignored.
    """
    demo = normalize_path(POSTGRESQL_DEMO)
    if normalize_path(bicep_file) != demo:
        return []

    matches = []
    for line in stderr.splitlines():
        diagnostic = DIAGNOSTIC_PATTERN.match(line.strip())
        if diagnostic is None:
            continue
        if diagnostic.group("code") not in TLS_DIAGNOSTIC_CODES:
            continue
        if normalize_path(diagnostic.group("path")) != demo:
            continue
        if TLS_PROPERTY_PATTERN.search(diagnostic.group("message")):
            matches.append(line.strip())
    return matches


def main():
    # set the bicep binary name based on the OS
    if os.name == 'nt':
        bicep_bin = 'bicep.exe'
        home_path = os.environ['USERPROFILE']
    else:
        bicep_bin = 'bicep'
        home_path = os.environ['HOME']

    # set the default Bicep path based on the runner
    if os.environ.get("GITHUB_ACTIONS", "false") == "false":
        print("Running locally")
        bicep_path = os.path.join(home_path, '.rad', 'bin')
    else:
        print("Running in GitHub Actions", flush=True)
        bicep_path = "."

    # allow override through an environment variable
    bicep_path = os.environ.get("BICEP_PATH", bicep_path)
    bicep_executable = os.path.join(bicep_path, bicep_bin)

    print(f"Using Bicep binary: {bicep_executable}", flush=True)

    files = []
    failures = []
    warnings = []

    # Walk the directory tree and find all .bicep files
    for root, _, filenames in os.walk("."):
        for filename in filenames:
            if filename.endswith(".bicep"):
                files.append(os.path.join(root, filename))

    print("Restoring Bicep artifacts...", flush=True)
    restore_result = subprocess.run(
        [bicep_executable, "restore", "--pattern", "**/*.bicep"],
    )
    if restore_result.returncode != 0:
        exit(restore_result.returncode)

    def validate_file(f):
        print(f"Validating {f}...", flush=True)

        result = subprocess.run(
            [bicep_executable, "build", f, "--stdout"],
            stderr=subprocess.PIPE,
            stdout=subprocess.DEVNULL,
        )
        stderr = result.stderr.decode("utf-8")
        exitcode = result.returncode

        if "Warning" in stderr:
            warnings.append(f)
            print(stderr, flush=True)

        tls_diagnostics = find_unsupported_tls_diagnostics(f, stderr)
        if tls_diagnostics:
            print(f"Unsupported PostgreSQL TLS setting in {f}:", flush=True)
            for diagnostic in tls_diagnostics:
                print(f"  {diagnostic}", flush=True)

        if exitcode != 0 or "Error" in stderr or tls_diagnostics:
            failures.append(f)
            print(stderr, flush=True)

    with concurrent.futures.ThreadPoolExecutor(max_workers=num_workers) as executor:
        futures = [executor.submit(validate_file, f) for f in files]
    concurrent.futures.wait(futures)

    for f in failures:
        print(f"Failed: {f}", flush=True)

    for f in warnings:
        print(f"Warning: {f}", flush=True)

    exit(len(failures))


if __name__ == "__main__":
    main()
