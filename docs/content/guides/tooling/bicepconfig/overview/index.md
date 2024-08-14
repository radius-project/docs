---
type: docs
title: "Overview: Bicep configuration"
linkTitle: "Overview"
description: "Setup the Bicep configuration file to author and deploy Radius-types"
weight: 100
categories: "Overview"
tags: ["Bicep"]
---

To use the features provided by the official Bicep compiler with Radius, certain configurations need to be defined. These are defined in a `bicepconfig.json` file that lives in your application's directory. 

## What is a `bicepconfig.json`?

The `bicepconfig.json` allows the Bicep compiler to consume and use Radius-types stored in an OCI registry. There are two extensions that are enabled by default in the `bicepconfig.json` so that you can use Radius and AWS resources. The "radius" extension contains the schema information for all Radius-maintained resources, and the "aws" extension contains the schema information for AWS resources. You can optionally add any other settings that are relevant to your application. There are two ways to generate a `bicepconfig.json` with Radius. 

## Automatically generate a `bicepconfig.json` via `rad init`

{{< read file= "/shared-content/installation/bicepconfig/rad-init.md" >}}

## Manually create a `bicepconfig.json` 

{{< read file= "/shared-content/installation/bicepconfig/manual.md" >}}

## Author and deploy Radius-types

{{< alert title="Replace import statements with extension" color="warning" >}} Radius is now merged with the official Bicep. If you have bicep files with the following import statements, please replace them with as needed.

 1. `import radius as radius` should become `extension radius` to use Radius types 
 1. `import aws as aws` should become `extension aws` to use AWS types
 1. `import kubernetes as kubernetes {}` should become `extension kubernetes with {} as kubernetes` to use Kubernetes types
{{< /alert >}}

Once you have a `bicepconfig.json` file in your application's directory, you can author and deploy Radius-types. 

{{< rad file="snippets/app.bicep" embed=true >}}