---
type: docs
title: "Quickstart: Deploy Recipes in your Radius Application"
linkTitle: "Deploy Recipes in your Radius Application"
description: "Learn how to use community 'dev' Recipes and your custom made Recipes in a Radius Environment"
weight: 500
slug: "recipes"
---

This quickstart will teach you:

* How to use community “dev” Recipes in your Radius Environment
* How to author your own Recipes
* How to deploy your own Recipes in your Radius Environment

## Prerequisites

* Make sure you have an [Azure account](https://azure.microsoft.com/en-us/free/search) and [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed on your machine.
* [rad CLI]({{< ref getting-started >}})
* [Supported Kubernetes cluster]({{< ref kubernetes >}})

## Overview

Recipes enable a separation of concerns between infrastructure teams and developers by automating infrastructure deployment.

Recipes are a collection of infrastructure resources that can be deployed as part of a Radius application. Currently Recipes can be written in [Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) and can be stored in [Azure Container Registries](https://azure.microsoft.com/en-us/products/container-registry/).

{{% alert title="📄 Dive deep" color="primary" %}}
To learn more about Recipes as a developer concept visit the [Recipe developer guide]({{< ref recipes >}}).
{{% /alert %}}

To get a practical understanding of how Recipes work, we will be using the Radius application found in our [Getting Started guide]({{< ref first-app >}}) and combining it with both the community `dev` Redis Cache Recipe and an Azure Redis Cache Recipe that you will create. 

<img src="recipe-quickstart-diagram.png" alt="Screenshot of the" style="width:100%" >


## Step 1: Initialize Radius

Navigate to the directory where you want to create your application and run the following command:

1. Use the `rad init` command to initialize a new environment:

   ```bash
   rad init
   ```

   Follow the prompts to install the [control plane services]({{< ref architecture >}}), create an [environment resource]({{< ref environments >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:

   * **Azure provider** - An [Azure cloud provider]({{<ref providers>}}) allows you to deploy and manage Azure resources as part of your application. Enter 'y' and follow the instructions. Provide a valid Azure service principal with the proper permissions.
   * **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `azure`.


## Step 2: Community `dev` Recipe deployment

1. Create a Bicep file `app.bicep` with the following content:

   {{< rad file="snippets/app.bicep" embed=true >}}

The code you just added references a container `demo` which is a container that runs the `radius.azurecr.io/tutorial/webapp` image, this image is published by the Radius team to a public registry, so you do not need to create it. It then creates a connection between `demo` and a database `db` which deploys a Recipe called `redis-kubernetes` which can be found inside your Radius environment thanks to community `dev` Recipes which are linked during a Radius environment initialization.

{{% alert title="📄 Dive deep" color="primary" %}}

To learn more about app models in Radius visit the [application model concept page({{< ref appmodel-concept >}}).

{{% /alert %}}

1. To understand what community `dev` Recipes you have available you can run the following command:

   ```bash
   rad recipe list
   ```

   You should see the following output:

   ```bash
   NAME                 TYPE                 TEMPLATE
   redis-kubernetes     Redis Cache          radius.azurecr.io/recipes/redis-kubernetes:latest
   ```

   This is the Recipe that we are using in our application.

It's now time to deploy the application, run the following command:

1. Use the `rad run ` command to initialize a new environment:

   ```bash
   rad run app.bicep
   ```

You've now deployed your application to your Kubernetes cluster. You can access your application by opening http://localhost:3000 in a browser.

## Step 3: Custom Recipe deployment

Today, Recipes only support the Bicep IaC language. Your custom Recipe template will begin with a new Bicep file, which will contain all of the resources you want to automatically deploy for each resource that runs the Recipe.

{{% alert title="Dive deep" color="primary" %}}
To learn more about Recipes as a concept from the infra team perspective visit the [administrator guide]({{< ref custom-recipes.md >}})
{{% /alert %}}
