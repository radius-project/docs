import os
import re
import subprocess
import concurrent.futures

num_workers = 5


def is_validation_failure(filename, stderr, exitcode):
    if exitcode != 0 or "Error" in stderr:
        return True

    sample_path = os.path.normcase(os.path.abspath(filename.replace("\\", "/")))
    if sample_path not in {
        os.path.normcase(os.path.abspath(path))
        for path in (
            "docs/static/samples/demo/app-postgresql.bicep",
            "docs/public/samples/demo/app-postgresql.bicep",
        )
    }:
        return False

    for line in stderr.splitlines():
        diagnostic = re.match(
            r"^(.+)\(\d+,\d+\)\s*:\s*(?:Warning|Error)\s+BCP03[67]:"
            r"\s+The property ([\"'])tls\2(?:\s|$)",
            line,
        )
        if diagnostic:
            diagnostic_path = os.path.normcase(os.path.abspath(
                diagnostic.group(1).replace("\\", "/")
            ))
            if diagnostic_path == sample_path:
                return True
    return False


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

        if is_validation_failure(f, stderr, exitcode):
            failures.append(f)
            print(stderr, flush=True)

    with concurrent.futures.ThreadPoolExecutor(max_workers=num_workers) as executor:
        futures = [executor.submit(validate_file, f) for f in files]
    concurrent.futures.wait(futures)

    for f in failures:
        print(f"Failed: {f}", flush=True)

    for f in warnings:
        print(f"Warning: {f}", flush=True)

    return len(failures)


if __name__ == "__main__":
    raise SystemExit(main())
