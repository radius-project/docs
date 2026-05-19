import concurrent.futures
import os
from pathlib import Path
import re
import subprocess

num_workers = 5

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

extension_pattern = re.compile(r'^\s*extension\s+([A-Za-z0-9_-]+)\s*$', re.MULTILINE)
registry_reference_pattern = re.compile(r'br:[^\s\'"]+')
repo_root = Path(".").resolve()

# Walk the directory tree and find all .bicep files
for root, _, filenames in os.walk("."):
    for filename in filenames:
        if filename.endswith(".bicep"):
            files.append(os.path.join(root, filename))


def find_bicep_config_path(file_path):
    current_path = Path(file_path).resolve().parent

    while True:
        config_path = current_path / "bicepconfig.json"
        if config_path.exists():
            return str(config_path.relative_to(repo_root))

        if current_path == repo_root:
            return None

        current_path = current_path.parent


def requires_restore(file_path):
    file_contents = Path(file_path).read_text(encoding="utf-8")
    extensions = tuple(sorted(set(extension_pattern.findall(file_contents))))
    registry_references = tuple(sorted(set(registry_reference_pattern.findall(file_contents))))

    if not extensions and not registry_references:
        return None

    return (find_bicep_config_path(file_path), extensions, registry_references)


def restore_file(f):
    print(f"Restoring artifacts for {f}...", flush=True)

    result = subprocess.run(
        [bicep_executable, "restore", f],
        stderr=subprocess.PIPE,
        stdout=subprocess.DEVNULL,
    )
    stderr = result.stderr.decode("utf-8")
    exitcode = result.returncode

    if exitcode != 0 or "Error" in stderr:
        failures.append(f)
        print(stderr, flush=True)
        return False

    return True

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

    if exitcode != 0 or "Error" in stderr:
        failures.append(f)
        print(stderr, flush=True)


files_to_skip = set()
restore_targets = {}

for file_path in files:
    restore_key = requires_restore(file_path)
    if restore_key:
        restore_targets.setdefault(restore_key, []).append(file_path)

for restore_group in restore_targets.values():
    if not restore_file(restore_group[0]):
        files_to_skip.update(restore_group)

with concurrent.futures.ThreadPoolExecutor(max_workers=num_workers) as executor:
    futures = [executor.submit(validate_file, f) for f in files if f not in files_to_skip]
concurrent.futures.wait(futures)

for f in failures:
    print(f"Failed: {f}", flush=True)

for f in warnings:
    print(f"Warning: {f}", flush=True)

exit(len(failures))
