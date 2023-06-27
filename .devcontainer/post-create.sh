#!/bin/bash

# Initialize submodules
git submodule update --init --recursive

# Clone radius repo
git clone https://github.com/project-radius/radius.git

# Install dependencies
pushd ./docs
sudo npm install -D --save autoprefixer
sudo npm install -D --save postcss-cli
cd themes/docsy
npm install
popd

# Generate CLI docs
pushd ./radius
go run ./cmd/docgen/main.go ../docs/content/reference/cli
popd

# Generate Swagger docs
mkdir -p ./docs/static/swagger
cp -r ./radius/swagger ./docs/static/

# Set Radius Bicep extension version
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" = "edge" ]; then
    RADIUS_VERSION=edge
else
    ## If CURRENT_BRANCH matches a regex of the form "v0.20", set RADIUS_VERSION to the matching string minus the "v"
    if [[ "$CURRENT_BRANCH" =~ ^v[0-9]+\.[0-9]+$ ]]; then
        RADIUS_VERSION=${CURRENT_BRANCH:1}
    else
        ## Otherwise, set RADIUS_VERSION to "edge"
        RADIUS_VERSION=edge
    fi
fi

## Download Bicep extension
curl https://get.radapp.dev/tools/vscode-extensibility/$RADIUS_VERSION/rad-vscode-bicep.vsix --output .devcontainer/rad-vscode-bicep.vsix

## Install Radius Bicep extension
code --install-extension .devcontainer/rad-vscode-bicep.vsix