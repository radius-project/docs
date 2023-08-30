# Radius documentation

This directory contains the files to generate the https://radapp.dev site. Please go there to consume Radius docs. This document will describe how to build Radius docs locally.

## Codespace

The easiest way to get up and runnning with a docs environment is a GitHub codespace. Visit [this link]() to get up and running in minutes.

1. Open codespace
2. Ensure postCreate script has completed (takes ~2 minutes to build CLI docs)
3. `cd docs` to change into the docs directory
4. `hugo server` to run a docs server
5. Click the `localhost:1313` link in your terminal to open the Codespace tunnel to the page

## Pre-requisites

- [Hugo extended version](https://gohugo.io/getting-started/installing)
- [Node.js](https://nodejs.org/en/)

## Environment setup

1. Ensure pre-requisites are installed
2. Clone this repository and the radius repository
   ```sh
   git clone https://github.com/radius-project/radius.git
   git clone https://github.com/radius-project/docs.git
   ```
3. Generate CLI docs:
   ```sh
   pushd radius
   go run ./cmd/docgen/main.go ../docs/docs/content/reference/cli
   popd
   ```
4. Change to docs directory:
   ```sh
   cd docs/docs
   ```
5. Update submodules:
   ```sh
   git submodule update --init --recursive
   ```
6. Install npm packages:
   ```sh
   npm install
   ```
7. Install Docsy dependencies
   ```sh
   pushd ./themes/docsy
   sudo npm install
   popd
   ```

## Run local server

1. Make sure you're still in the `docs/docs` directory
2. Run
   ```sh
   hugo server
   ```
3. Navigate to `http://localhost:1313/`
