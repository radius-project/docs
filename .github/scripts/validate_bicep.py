import os
import subprocess
import concurrent.futures

# set the bicep binary name based on the OS
if os.name == 'nt':
    bicep_bin = 'rad-bicep.exe'
    home_path = os.environ['USERPROFILE']
else:
    bicep_bin = 'rad-bicep'
    home_path = os.environ['HOME']

# set the default Bicep path based on the runner
if os.environ.get("GITHUB_ACTIONS", "false") == "false":
    print("Running locally")
    bicep_path = os.path.join(home_path, '.rad', 'bin')
else:
    print("Running in GitHub Actions")
    bicep_path = "."

# allow override through an environment variable
bicep_path = os.environ.get("BICEP_PATH", bicep_path)
bicep_executable = os.path.join(bicep_path, bicep_bin)

print(f"Using Bicep binary: {bicep_executable}")

files = []
failures = []

# Walk the directory tree and find all .bicep files
for root, _, filenames in os.walk("."):
    for filename in filenames:
        if filename.endswith(".bicep"):
            files.append(os.path.join(root, filename))

def validate_file(f):
    print(f"Validating {f}...")

    result = subprocess.run([bicep_executable, "build", f, "--stdout"], capture_output=True)
    stderr = result.stderr.decode("utf-8")
    exitcode = result.returncode

    if exitcode != 0:
        failures.append(f)
        print(stderr)

with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
    futures = [executor.submit(validate_file, f) for f in files]
concurrent.futures.wait(futures)

for f in failures:
    print(f"Failed: {f}")

exit(len(failures))
