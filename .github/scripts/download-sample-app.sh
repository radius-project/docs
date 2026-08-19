#!/usr/bin/env bash
# ------------------------------------------------------------
# Copyright 2023 The Radius Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ------------------------------------------------------------

# Download the sample application Bicep files from the radius-project/samples repository at
# the ref that matches this docs branch, and write them under docs/static so the site can
# both embed them (offline, reproducible builds) and serve each at a stable URL such as
# https://docs.radapp.io/samples/demo/app.bicep (Hugo serves static/ from the site root).
#
# Every file in SAMPLE_DIR matching FILE_GLOB is copied, so adding a new *.bicep to the
# samples/demo directory upstream is picked up automatically with no change to this script.
#
# Ref selection:
#   1. The `version` param in docs/config.toml (for example "edge" or "v0.59"). The
#      release process sets this per branch and it matches a samples branch name.
#   2. If listing that ref fails or returns no matches, fall back to DEFAULT_REF.
#
# Override any of these with environment variables (defaults in parentheses):
#   SAMPLES_REPO  (radius-project/samples)
#   SAMPLE_DIR    (samples/demo)              directory in the samples repo to copy from
#   FILE_GLOB     (*.bicep)                   which files in SAMPLE_DIR to copy
#   CONFIG_FILE   (docs/config.toml)
#   DEST_DIR      (docs/static/samples/demo)  directory to write the files into
#   DEFAULT_REF   (v0.59)
#
# Set GITHUB_TOKEN to raise the GitHub API rate limit (the workflow passes it automatically).

set -euo pipefail

SAMPLES_REPO="${SAMPLES_REPO:-radius-project/samples}"
SAMPLE_DIR="${SAMPLE_DIR:-samples/demo}"
FILE_GLOB="${FILE_GLOB:-*.bicep}"
CONFIG_FILE="${CONFIG_FILE:-docs/config.toml}"
DEST_DIR="${DEST_DIR:-docs/static/samples/demo}"
DEFAULT_REF="${DEFAULT_REF:-v0.59}"

# Read the [params].version value from config.toml. It is the first `version = "..."`
# entry in the file (the [[params.versions]] menu entries come later), so -m1 selects it.
# `tag_version` and `version_menu` do not match because the regex anchors `version =`.
VERSION=""
if [[ -f "${CONFIG_FILE}" ]]; then
  VERSION="$(grep -m1 -E '^[[:space:]]*version[[:space:]]*=' "${CONFIG_FILE}" \
    | sed -E 's/^[[:space:]]*version[[:space:]]*=[[:space:]]*["'"'"']([^"'"'"']+)["'"'"'].*/\1/')" || true
fi

REF="${VERSION:-${DEFAULT_REF}}"

# List the files in SAMPLE_DIR at a ref that match FILE_GLOB, one name per line, via the
# GitHub Contents API. Uses GITHUB_TOKEN when set to raise the API rate limit.
list_files() {
  local ref="$1"
  local api="https://api.github.com/repos/${SAMPLES_REPO}/contents/${SAMPLE_DIR}?ref=${ref}"
  local -a auth=()
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    auth=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
  fi
  local json
  if ! json="$(curl -sSfL --retry 5 --retry-delay 2 \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      ${auth[@]+"${auth[@]}"} "${api}")"; then
    return 1
  fi
  printf '%s' "${json}" | python3 -c 'import json, sys, fnmatch
data = json.load(sys.stdin)
for e in data:
    if e.get("type") == "file" and fnmatch.fnmatch(e["name"], sys.argv[1]):
        print(e["name"])' "${FILE_GLOB}"
}

# Download one file from SAMPLE_DIR at a ref into DEST_DIR.
download() {
  local ref="$1" name="$2"
  local url="https://raw.githubusercontent.com/${SAMPLES_REPO}/${ref}/${SAMPLE_DIR}/${name}"
  echo "Downloading ${url}"
  # -f fails on HTTP errors; --retry covers transient network and 5xx errors.
  curl -sSfL --retry 5 --retry-delay 2 -o "${DEST_DIR}/${name}" "${url}"
}

EFFECTIVE_REF="${REF}"
FILES="$(list_files "${REF}" || true)"
if [[ -z "${FILES}" && "${REF}" != "${DEFAULT_REF}" ]]; then
  echo "Listing ${SAMPLE_DIR} at '${REF}' failed or was empty; falling back to '${DEFAULT_REF}'." >&2
  EFFECTIVE_REF="${DEFAULT_REF}"
  FILES="$(list_files "${DEFAULT_REF}" || true)"
fi

if [[ -z "${FILES}" ]]; then
  echo "Error: no ${FILE_GLOB} files found in ${SAMPLES_REPO}/${SAMPLE_DIR}." >&2
  exit 1
fi

mkdir -p "${DEST_DIR}"

COUNT=0
while IFS= read -r name; do
  [[ -z "${name}" ]] && continue
  download "${EFFECTIVE_REF}" "${name}"
  if [[ ! -s "${DEST_DIR}/${name}" ]]; then
    echo "Error: downloaded file ${DEST_DIR}/${name} is empty." >&2
    exit 1
  fi
  COUNT=$((COUNT + 1))
done <<< "${FILES}"

echo "Wrote ${COUNT} file(s) to ${DEST_DIR} from ${SAMPLES_REPO}/${SAMPLE_DIR}@${EFFECTIVE_REF}."
