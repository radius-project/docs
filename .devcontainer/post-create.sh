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
