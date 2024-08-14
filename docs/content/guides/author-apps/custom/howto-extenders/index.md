---
type: docs
title: "How-To: Model any resource with an extender"
linkTitle: "Extenders"
description: "Learn how to use extenders in an application"
weight: 300
---

This guide will walk you through how to use an [extender]({{< ref "/guides/author-apps/custom/overview#extenders" >}}) in an application to model resources beyond those currently built into Radius. These might be abstractions or resources unique to your organization, or resources that don't yet have a native Radius type.

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})

## Step 1: Register an extender Recipe

In this guide you will leverage a [Recipe]({{< ref "/guides/recipes/overview" >}}) to deploy backing infrastructure for your resource. Begin by registering the 'extender-postgresql' Recipe in your environment:

```bash
rad recipe register postgresql --resource-type "Applications.Core/extenders" --template-kind bicep --template-path "ghcr.io/radius-project/recipes/local-dev/postgresql:latest"
```

## Step 2: Define an extender

Open a new file named `app.bicep` and define an extender:

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 3: Add a container

Add a container to your `app.bicep` file, accessing the extender's properties and secrets:

{{< rad file="snippets/app-container.bicep" embed=true marker="//CONTAINER" >}}

## Step 4: Deploy the app

Deploy and [run]({{< ref rad_run >}}) the app using the following command:

```bash
rad run app.bicep -a demo
```

You should see your application deployed:

```
Building .\app.bicep...
Deploying template '.\app.bicep' for application 'demo' and environment 'default' from workspace 'default'...

Deployment In Progress...


Deployment Complete

Resources:
    demo            Applications.Core/containers
    extender        Applications.Core/extenders

Starting log stream...

demo-bb9df8798-b68rc › demo
demo-bb9df8798-b68rc demo Using in-memory store: no connection string found
demo-bb9df8798-b68rc demo Server is running at http://localhost:3000
demo-bb9df8798-b68rc demo [port-forward] connected from localhost:3000 -> ::3000
```

## Step 5: Test the app

Visit [https://localhost:3000](https://localhost:3000) to see your app running. You should see the environment variables and secrets you referenced in your container.

## Cleanup

To clean up the resources created in this guide, run:

```bash
rad app delete demo -y
```
