---
type: docs
title: "Overview: Bicep configuration"
linkTitle: "Overview"
description: "Setup the Bicep configuration file to author and deploy Radius-managed types"
weight: 100
categories: "Overview"
tags: ["Bicep"]
---

In order to use the features provided by the official Bicep compiler with Radius, certain configurations need to be defined. These are defined in a `bicepconfig.json` file that lives in your application's directory. There are two ways to generate a `bicepconfig.json` with Radius. 

## Option 1: Automatically generate a `bicepconfig.json` via `rad init`

1. Install Radius CLI

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

1. Create a new directory for your app and navigate into it:

```bash
mkdir first-app
cd first-app
```

Initialize Radius. Select `Yes` when asked to setup application in the current directory. This will automatically generate a `bicepconfig.json` with the correct setup in your application's directory. 

```bash
rad init
```

## Option 2: Manually create a `bicepconfig.json` 

1. Create a `bicepconfig.json` in your application's directory. `release-version` should correspond to the current release version in the form of `major.minor` (e.g. `0.36`). 

```json
{
	"experimentalFeaturesEnabled": {
		"extensibility": true,
		"extensionRegistry": true,
		"dynamicTypeLoading": true
	},
	"extensions": {
		"radius": "br:biceptypes.azurecr.io/radius:<release-version>",
		"aws": "br:biceptypes.azurecr.io/aws:<release-version>"
	}
}
```

A `bicepconfig.json` file is required to use Radius with the official Bicep compiler but you can optionally add any other settings that are relevant to your application. These configurations allow Bicep to consume and use Radius-managed types stored in an OCI registry. There are two extensions that are enabled by default in the `bicepconfig.json` so that you can use Radius and AWS resources. The "radius" extension contains the schema information for all Radius-maintained resources, and the "aws" extension contains the schema information for AWS resources. 