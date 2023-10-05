# Radius documentation

This directory contains the files to generate the https://docs.radapp.dev site. Please go there to consume Radius docs. This document will describe how to build Radius docs locally.

## Codespace

The easiest way to get up and runnning with a docs environment is a GitHub codespace.

1. Open codespace
2. Ensure postCreate script has completed (takes ~2 minutes)
3. Run `cd docs` to change into the docs directory
4. Run `npm run start` to run a docs server
5. Click the `localhost:1313` link in your terminal to open the Codespace tunnel to the page

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
   npm install
   ```

### Run local server

1. Make sure you're still in the `docs/docs` directory
1. Run:
   ```sh
   npm run start
   ```
1. Navigate to `http://localhost:1313/`

### Build website

1. Make sure you're still in the `docs/docs` directory
1. Run:
   ```sh
   npm run build
   ```
1. Docs website will be generated under `docs/public`
