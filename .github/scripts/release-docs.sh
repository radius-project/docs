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

if [[ -z "$VERSION_NUMBER" ]]; then
  echo "Error: VERSION_NUMBER is not set."
  exit 1
fi

# VERSION is the version number prefixed by 'v' (e.g. v0.1.0)
VERSION="v${VERSION_NUMBER}"

# CHANNEL is the major and minor version of the VERSION_NUMBER (e.g. 0.1)
CHANNEL="$(echo $VERSION_NUMBER | cut -d '.' -f 1,2)"

# CHANNEL_VERSION is the version with the 'v' prefix (e.g. v0.1)
CHANNEL_VERSION="v${CHANNEL}"

echo "Version number: ${VERSION_NUMBER}"
echo "Version: ${VERSION}"
echo "Channel: ${CHANNEL}"
echo "Channel version: ${CHANNEL_VERSION}"

echo "Creating release branch for ${REPOSITORY}..."

pushd $REPOSITORY

git checkout -B "${CHANNEL_VERSION}"

# In docs/config.toml, change baseURL to https://docs.radapp.io/ instead of https://edge.docs.radapp.io/
awk '{gsub(/baseURL = \"https:\/\/edge\.docs\.radapp.io\/\"/,"baseURL = \"https:\/\/docs.radapp.io\/\""); print}' docs/config.toml > docs/config.toml.tmp
mv docs/config.toml.tmp docs/config.toml

# In docs/config.toml, change version to VERSION instead of edge
VERSION_STRING_REPLACEMENT="version = \"${CHANNEL_VERSION}\""
awk -v REPLACEMENT="${VERSION_STRING_REPLACEMENT}" '{gsub(/version = \"edge\"/, REPLACEMENT); print}' docs/config.toml > docs/config.toml.tmp
mv docs/config.toml.tmp docs/config.toml

# In docs/config.toml, change version to CHANNEL_VERSION instead of latest or older version
DOC_VERSION_STRING_REPLACEMENT="version = \"${CHANNEL_VERSION}\""
sed -i.bak -E "s/^( *)[ \t]*version = \"(latest|v.*)\"/\1${DOC_VERSION_STRING_REPLACEMENT}/" docs/config.toml

# In docs/config.toml, change github_branch to CHANNEL_VERSION instead of edge
GITHUB_BRANCH_STRING_REPLACEMENT="github_branch = \"${CHANNEL_VERSION}\""
awk -v REPLACEMENT="${GITHUB_BRANCH_STRING_REPLACEMENT}" '{gsub(/github_branch = \"edge\"/, REPLACEMENT); print}' docs/config.toml > docs/config.toml.tmp
mv docs/config.toml.tmp docs/config.toml

# In docs/config.toml, change chart_version (Helm chart) to VERSION_NUMBER
CHART_VERSION_STRING_REPLACEMENT="chart_version = \"${VERSION_NUMBER}\""
awk -v REPLACEMENT="${CHART_VERSION_STRING_REPLACEMENT}" '{gsub(/chart_version = \"[^\n]+\"/, REPLACEMENT); print}' docs/config.toml > docs/config.toml.tmp
mv docs/config.toml.tmp docs/config.toml

# In docs/layouts/partials/hooks/body-end.html, change indexName to radapp-dev instead of radapp-dev-edge
awk '{gsub(/indexName: '\''radapp-dev-edge'\''/, "indexName: '\''radapp-dev'\''"); print}' docs/layouts/partials/hooks/body-end.html > docs/layouts/partials/hooks/body-end.html.tmp
mv docs/layouts/partials/hooks/body-end.html.tmp docs/layouts/partials/hooks/body-end.html

# Push changes to GitHub
git add --all
git commit -m "Update docs for ${VERSION}"
git push origin "${CHANNEL_VERSION}"

popd
