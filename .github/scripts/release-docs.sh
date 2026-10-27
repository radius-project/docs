#!/bin/bash

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

set -euo pipefail

VERSION_NUMBER="${1:-}" # (e.g. 0.1.0)
REPOSITORY="docs"

if [[ -z "${VERSION_NUMBER}" ]]; then
  echo "Error: VERSION_NUMBER is not set."
  exit 1
fi

if [[ -z "${GITHUB_REPOSITORY:-}" || -z "${GH_TOKEN:-}" ||
  -z "${BOT_NAME:-}" || -z "${BOT_EMAIL:-}" ]]; then
  echo "Error: GITHUB_REPOSITORY, GH_TOKEN, BOT_NAME, and BOT_EMAIL must be set."
  exit 1
fi

# VERSION is the version number prefixed by 'v' (e.g. v0.1.0)
VERSION="v${VERSION_NUMBER}"

# CHANNEL is the major and minor version of the VERSION_NUMBER (e.g. 0.1)
CHANNEL="$(echo "${VERSION_NUMBER}" | cut -d '.' -f 1,2)"

# CHANNEL_VERSION is the version with the 'v' prefix (e.g. v0.1)
CHANNEL_VERSION="v${CHANNEL}"

echo "Version number: ${VERSION_NUMBER}"
echo "Version: ${VERSION}"
echo "Channel: ${CHANNEL}"
echo "Channel version: ${CHANNEL_VERSION}"

echo "Creating release branch for ${REPOSITORY}..."

pushd "${REPOSITORY}" > /dev/null

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Error: Release publication requires a clean docs checkout."
  exit 1
fi
BASE_SHA="$(git rev-parse HEAD)"

# Replacements below are whitespace-, quote-, and comment-tolerant so they keep
# working even after `docs/config.toml` is reformatted.
#  - `[[:space:]]*` around `=` tolerates any spacing (none, single, multiple).
#  - `["\x27]` matches both double and single quotes.
#  - Optional trailing `(#.*)?` allows an inline TOML comment on the line.
#  - Each replacement re-emits the canonical taplo format: `key = "value"`.

# In docs/config.toml, change baseURL to https://docs.radapp.io/ instead of https://edge.docs.radapp.io/
sed -E -i 's|^[[:space:]]*baseURL[[:space:]]*=[[:space:]]*["\x27]https://edge\.docs\.radapp\.io/["\x27][[:space:]]*(#.*)?$|baseURL = "https://docs.radapp.io/"|' docs/config.toml

# In docs/config.toml, change version to CHANNEL_VERSION instead of edge
sed -E -i "s|^[[:space:]]*version[[:space:]]*=[[:space:]]*[\"\x27]edge[\"\x27][[:space:]]*(#.*)?$|version = \"${CHANNEL_VERSION}\"|" docs/config.toml

# In docs/config.toml, change github_branch to CHANNEL_VERSION instead of edge
sed -E -i "s|^[[:space:]]*github_branch[[:space:]]*=[[:space:]]*[\"\x27]edge[\"\x27][[:space:]]*(#.*)?$|github_branch = \"${CHANNEL_VERSION}\"|" docs/config.toml

# In docs/config.toml, change chart_version (Helm chart) to VERSION_NUMBER
sed -E -i "s|^[[:space:]]*chart_version[[:space:]]*=[[:space:]]*[\"\x27][^\"\x27]+[\"\x27][[:space:]]*(#.*)?$|chart_version = \"${VERSION_NUMBER}\"|" docs/config.toml

# Verify all expected replacements happened; fail fast if config.toml drifted.
for pair in \
  "baseURL|baseURL = \"https://docs.radapp.io/\"" \
  "version-edge|version = \"${CHANNEL_VERSION}\"" \
  "github_branch|github_branch = \"${CHANNEL_VERSION}\"" \
  "chart_version|chart_version = \"${VERSION_NUMBER}\""; do
  label="${pair%%|*}"
  expected="${pair#*|}"
  if ! grep -Fxq "${expected}" docs/config.toml; then
    echo "Error: expected line for '${label}' not found in docs/config.toml: ${expected}"
    exit 1
  fi
done

# In docs/config.toml, change the Algolia search indexName to radapp-dev instead of radapp-dev-edge
sed -E -i 's|^[[:space:]]*indexName[[:space:]]*=[[:space:]]*["\x27]radapp-dev-edge["\x27][[:space:]]*(#.*)?$|indexName = "radapp-dev"|' docs/config.toml

if ! grep -Fxq 'indexName = "radapp-dev"' docs/config.toml; then
  echo "Error: expected line for 'indexName' not found in docs/config.toml: indexName = \"radapp-dev\""
  exit 1
fi

# Only release configuration belongs in this commit.
git add -- docs/config.toml
if git diff --cached --quiet; then
  echo "Error: No changes to commit for ${CHANNEL_VERSION}."
  exit 1
fi

BLOB_SHA="$(base64 --wrap=0 docs/config.toml |
  jq --raw-input --slurp '{content: ., encoding: "base64"}' |
  gh api --method POST "repos/${GITHUB_REPOSITORY}/git/blobs" --input - --jq '.sha')"
TREE_SHA="$(jq --null-input \
  --arg base_tree "$(git rev-parse "${BASE_SHA}^{tree}")" \
  --arg mode "$(git ls-files --stage -- docs/config.toml | awk '{print $1}')" \
  --arg sha "${BLOB_SHA}" \
  '{base_tree: $base_tree, tree: [{path: "docs/config.toml", mode: $mode, type: "blob", sha: $sha}]}' |
  gh api --method POST "repos/${GITHUB_REPOSITORY}/git/trees" --input - --jq '.sha')"
if [[ "${TREE_SHA}" != "$(git write-tree)" ]]; then
  echo "Error: GitHub tree ${TREE_SHA} does not match the local release configuration."
  exit 1
fi

# As in samples, omit author/committer/signature so GitHub signs for the App.
COMMIT="$(jq --null-input \
  --arg message "$(printf 'Update docs for %s\n\nSigned-off-by: %s <%s>' "${VERSION}" "${BOT_NAME}" "${BOT_EMAIL}")" \
  --arg tree "${TREE_SHA}" --arg parent "${BASE_SHA}" \
  '{message: $message, tree: $tree, parents: [$parent]}' |
  gh api --method POST "repos/${GITHUB_REPOSITORY}/git/commits" --input -)"
COMMIT_SHA="$(jq --raw-output '.sha' <<< "${COMMIT}")"
if [[ ! "${COMMIT_SHA}" =~ ^[0-9a-f]{40}$ ]] ||
  ! jq --exit-status '.verification.verified == true' <<< "${COMMIT}" > /dev/null; then
  echo "Error: GitHub did not verify release commit ${COMMIT_SHA} ($(jq --raw-output '.verification.reason' <<< "${COMMIT}")). GH_TOKEN must be a GitHub App installation token."
  exit 1
fi

# A failed lookup is not evidence that the branch is absent.
REFERENCES="$(gh api "repos/${GITHUB_REPOSITORY}/git/matching-refs/heads/${CHANNEL_VERSION}")"
EXISTS="$(jq --raw-output --arg ref "refs/heads/${CHANNEL_VERSION}" \
  'any(.[]; .ref == $ref)' <<< "${REFERENCES}")"
if [[ "${EXISTS}" == true ]]; then
  gh api --method PATCH "repos/${GITHUB_REPOSITORY}/git/refs/heads/${CHANNEL_VERSION}" \
    -f sha="${COMMIT_SHA}" -F force=false --silent
else
  gh api --method POST "repos/${GITHUB_REPOSITORY}/git/refs" \
    -f ref="refs/heads/${CHANNEL_VERSION}" -f sha="${COMMIT_SHA}" --silent
fi
echo "Published verified docs commit ${COMMIT_SHA} to ${CHANNEL_VERSION}."

popd > /dev/null
