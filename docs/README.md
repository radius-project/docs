# Radius documentation

This directory contains the files to generate the <https://docs.radapp.io> site. Please go there to consume Radius docs. This document will describe how to build Radius docs locally.

## Codespace

The easiest way to get up and running with a docs environment is a GitHub codespace.

1. Open codespace
1. Ensure postCreate script has completed (takes ~2 minutes)
1. Run `cd docs` to change into the docs directory
1. Run `npm start` to run a docs server
1. Click the `localhost:1313` link in your terminal to open the Codespace tunnel to the page

## Local machine

### Pre-requisites

- [Node.js](https://nodejs.org/en/)

### Environment setup

1. Clone this repository:

   ```sh
   git clone https://github.com/radius-project/docs.git
   ```

1. Change to docs directory:

   ```sh
   cd docs/docs
   ```

1. Install npm packages:

   ```sh
   npm ci
   ```

### Run local server

1. Make sure you're still in the `docs/docs` directory
1. Run:

   ```sh
   npm start
   ```

1. Navigate to `http://localhost:1313/`

### Build website

1. Make sure you're still in the `docs/docs` directory
1. Run:

   ```sh
   npm run build
   ```

1. Docs website will be generated under `docs/public`

### Validate Bicep configuration

From the repository root, run the release tag-selection tests:

```sh
python3 -m unittest discover -s .github/scripts -p 'test_set_bicep_extension_tags.py'
```

The root `bicepconfig.json` uses the development `edge` tags. The docs release script selects the `major.minor` channel for stable releases and the full version for release candidates. It updates only the canonical production GHCR development references, preserving explicit stable tags, manifest pins, custom registries, and local extensions. Do not run the release script for local validation: it creates a branch, commits, and pushes.

Bicep validation uses v0.46.1, with `experimentalFeaturesEnabled.ociEnabled` enabled in the effective configuration. After both production GHCR packages are publicly available, point `BICEP_PATH` at a directory containing that `bicep` binary and run:

```sh
BICEP_PATH=/path/to/bicep-directory python3 .github/scripts/validate_bicep.py
```

This command restores extensions and compiles the examples; it does not deploy them. An unavailable public package blocks this check. Radius v0.61.1 bundles Bicep v0.46.1, but restores and compilation must also be verified with the released Radius CLI before the documentation cutover. A standalone compiler check does not certify the released CLI or its generated configuration.
