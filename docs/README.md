# Radius documentation

This directory contains the Hugo project for the [Radius documentation](https://docs.radapp.io/). Follow these instructions to build a single branch locally. See [Hosting](../README.md#-hosting) for the combined `edge` and `latest` site.

## Codespace

The easiest way to get up and running with a docs environment is a GitHub codespace.

1. Open codespace
1. Wait for `postCreateCommand` to install the locked dependencies
1. Run `cd docs` to change into the docs directory
1. Run `npm start` to run a docs server
1. Open the URL printed by Hugo in the terminal

## Local machine

### Pre-requisites

- [Node.js](https://nodejs.org/en/)
- [Go](https://go.dev/dl/) to resolve the Docsy Hugo module (see `go.mod`).

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

   This installs the pinned Hugo and Dart Sass binaries. Run Hugo through the npm scripts so it can find `sass`; no global Sass installation is needed.

### Run local server

1. Make sure you're still in the `docs/docs` directory
1. Run:

   ```sh
   npm start
   ```

1. Open the URL printed by Hugo in the terminal.

### Build website

1. Make sure you're still in the `docs/docs` directory
1. Run:

   ```sh
   npm run build
   ```

1. Docs website will be generated under `docs/public`

After updating Docsy in `go.mod`, run `npm run hugo -- mod npm pack` and `npm install` in this directory to refresh the theme's Bootstrap and Font Awesome workspace and lockfile.

The `adm-zip` override in `package.json` pins the patched ZIP reader used by the Hugo installer on Windows. Remove it once `hugo-extended` itself requires a patched version.

For release branches that still use the old LibSass theme, the Pages build uses the theme and Sass tools pinned on `edge`. It keeps the release branch's Hugo binary and content without changing the branch.
