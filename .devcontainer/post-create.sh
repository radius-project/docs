#!/bin/bash

# Clone radius repo
git clone https://github.com/radius-project/radius.git

# Initialize docs package
cd docs
npm install

# Generate Swagger docs
mkdir -p ./docs/static/swagger
cp -r ./radius/swagger ./docs/static/
