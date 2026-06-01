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

set -xe

VERSION_NUMBER=$1 # (e.g. 0.1.0)
REPOSITORY="docs"

if [[ -z "${VERSION_NUMBER}" ]]; then
  echo "Error: VERSION_NUMBER is not set."
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

pushd $REPOSITORY

git checkout -B "${CHANNEL_VERSION}"

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

# In docs/layouts/partials/hooks/body-end.html, change indexName to radapp-dev instead of radapp-dev-edge
awk '{gsub(/indexName: '\''radapp-dev-edge'\''/, "indexName: '\''radapp-dev'\''"); print}' docs/layouts/partials/hooks/body-end.html > docs/layouts/partials/hooks/body-end.html.tmp
mv docs/layouts/partials/hooks/body-end.html.tmp docs/layouts/partials/hooks/body-end.html

# Push changes to GitHub
git add --all
git commit -m "Update docs for ${VERSION}"
git push origin "${CHANNEL_VERSION}"

popd
