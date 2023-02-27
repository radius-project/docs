---
type: docs
title: "Quickstart: Author and deploy a Recipe resource"
linkTitle: "Author and deploy a Recipe resource"
description: "Learn about how to author a Recipe and deploy a Redis Cache in Azure with Radius"
weight: 500
slug: "recipes"
---

This quickstart will teach you:
* How to author a Recipe template
* How to store your Recipe template
* How to register a Recipe to a Radius environment
* How to deploy a Radius application that leverages a Recipe

## Prerequisites

- Make sure you have an [Azure account](https://azure.microsoft.com/en-us/free/search) and [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed on your machine.
- [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) installed on your cluster
- [rad CLI]({{< ref getting-started >}})
- [Supported Kubernetes cluster]({{< ref kubernetes >}})

## Step 1: Initialize Radius

Create a [Radius environment]({{< ref environments >}}) where you will deploy your application.

1. You can view the current context for kubectl by running:

   ```bash
   kubectl config current-context
   ```

1. Use the `rad init` command to initialize a new environment into your current kubectl context:

   ```bash
   rad init
   ```

   Follow the prompts to install the [control plane services]({{< ref architecture >}}), create an [environment resource]({{< ref environments >}}), and create a [local workspace]({{< ref workspaces >}}). You will be asked for:

   - **Namespace** - When an application is deployed, this is the namespace where your containers and other Kubernetes resources will be run. By default, this will be in the `default` namespace.
   {{% alert title="💡 About namespaces" color="success" %}} When you initialize a Radius Kubernetes environment, Radius installs the control plane resources within the `radius-system` namespace in your cluster, separate from your applications. The namespace specified in this step will be used for your application deployments.
   {{% /alert %}}
   -  **Add Azure provider** - An [Azure cloud provider]({{<ref providers>}}) allows you to deploy and manage Azure resources as part of your application. Enter 'y' and follow the instructions. Provide a valid Azure service principal with the proper permissions.
   - **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `mycoolenv`.

## Step 2: Create a Recipe template with Azure Cache for Redis

Today, Recipes only support the Bicep IaC language. Your custom Recipe template will begin with a new Bicep file, which will contain all of the resources you want to automatically deploy for each resource that runs the Recipe.

{{% alert title="Learn more about authoring Recipes" color="warning" %}}
If you're curious about learning more about Recipes and how to author them visit the [administrator guide]({{< ref custom-recipes.md >}})
{{% /alert %}}

{{< tabs "Bicep" >}}

{{% codetab %}}

{{% /codetab %}}
