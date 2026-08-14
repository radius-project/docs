---
type: docs
title: "How to use other container platforms"
linkTitle: "Use other container platforms"
description: "Learn how to use other container platforms using Recipe Packs"
weight: 500
---

In Radius, every resource in an application is deployed through a [recipe]({{< ref "/concepts/recipe-packs" >}}), including the application's containers. A container is modeled with the `Radius.Compute/containers` Resource Type, and just like a database or a message queue, Radius provisions it by running the recipe that the Environment's [Recipe Pack]({{< ref "/extensibility/recipe-packs" >}}) maps to that Resource Type. Because the container recipe is customizable like any other recipe, you control which platform your containers run on by choosing the Recipe Pack, without changing the application definition.

## The default Recipe Pack deploys containers to Kubernetes

Out of the box, Radius comes configured with a `default` Recipe Pack that deploys every resource, including containers, to Kubernetes. When you install Radius with `rad initialize`, the Kubernetes Recipe Pack is assigned to the `default` Environment, so `Radius.Compute/containers` resources run as Kubernetes Deployments with no additional configuration. The same pack also provides recipes for the other Resource Types, such as databases and caches, so a newly installed Radius can deploy a complete application to Kubernetes immediately.

Because the container recipe is defined in a Recipe Pack like every other recipe, you can change where containers run by assigning an alternative Recipe Pack whose `Radius.Compute/containers` recipe targets a different platform.

## Use an alternative container platform

To run containers on a platform other than Kubernetes, assign the Environment a Recipe Pack whose `Radius.Compute/containers` recipe provisions the container on that platform. The [Radius community maintains Recipe Packs](https://github.com/radius-project/resource-types-contrib/tree/main/recipe-packs) for several platforms, or you can author your own by following [How to manage Recipe Packs]({{< ref "/extensibility/recipe-packs" >}}).

Each Resource Type can have only one recipe across all the Recipe Packs assigned to an Environment. Assigning a Recipe Pack that provides a `Radius.Compute/containers` recipe therefore replaces the default Kubernetes container recipe for that Environment. Application definitions do not change: the same `Radius.Compute/containers` resource deploys to the new platform.

The rest of this guide walks through the `azure-aci` Recipe Pack, which deploys containers to Azure Container Instances (ACI).

## Example: deploy containers to Azure Container Instances

The `azure-aci` Recipe Pack provisions `Radius.Compute/containers` on Azure Container Instances, along with the `Radius.Compute/persistentVolumes` and `Radius.Security/secrets` those containers use, backed by Azure Files and Azure Key Vault. For more information on the platform itself, consult the [Azure Container Instances documentation](https://learn.microsoft.com/azure/container-instances/). To see exactly how these resources are provisioned, review the [ACI recipes in `resource-types-contrib`](https://github.com/radius-project/resource-types-contrib/tree/main/Compute/containers/recipes/azure/bicep).

### Prerequisites

The ACI recipes provision Azure resources, so before you use the pack you need:

- **Azure credentials registered with Radius.** See [How to configure cloud provider credentials]({{< ref "/installation/cloud-providers" >}}).
- **An Environment with the Azure provider configured** with the Azure subscription ID and resource group the recipes provision into. See [How to design and manage Environments]({{< ref "/management/environments/#update-an-environment" >}}).

### Step 1: Deploy the ACI Recipe Pack

The `azure-aci` Recipe Pack is maintained in the [`resource-types-contrib`](https://github.com/radius-project/resource-types-contrib/tree/main/recipe-packs/azure-aci) repository, where it is defined as a single `Radius.Core/recipePacks` resource that maps each Resource Type to its published ACI recipe. Deploy the pack directly from its URL. `rad deploy` resolves and deploys remote Bicep templates, so you do not need to clone the repository or author the file locally:

```bash
rad deploy https://github.com/radius-project/resource-types-contrib/blob/main/recipe-packs/azure-aci/azure-aci.bicep
```

This creates the `azure-aci` Recipe Pack in the Radius control plane. To review the exact recipes and source versions the pack wires together, open [`azure-aci.bicep`](https://github.com/radius-project/resource-types-contrib/blob/main/recipe-packs/azure-aci/azure-aci.bicep).

### Step 2: Assign the Recipe Pack to your Environment

Use [`rad environment update`]({{< ref rad_environment_update >}}) to assign the `azure-aci` Recipe Pack to your Azure-configured Environment. This replaces the container recipe so subsequent deployments run containers on ACI:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment update <environment-name> \
  --recipe-packs azure-aci \
  --preview
```

The `--recipe-packs` option replaces the Environment's complete Recipe Pack list rather than appending to it, so include every Recipe Pack the Environment should use. Because the `azure-aci` pack covers only `Radius.Compute/containers`, `Radius.Compute/persistentVolumes`, and `Radius.Security/secrets`, assign it alongside any additional Recipe Packs that provide the other Resource Types your applications use, such as a data Recipe Pack:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment update <environment-name> \
  --recipe-packs azure-aci,data-recipes \
  --preview
```

### Step 3: Deploy an application

Deploy an application to the Environment as you normally would:

```bash
rad deploy app.bicep
```

Its `Radius.Compute/containers` resources now run on Azure Container Instances instead of Kubernetes. The application definition is unchanged: only the Recipe Pack assigned to the Environment determines where the containers run.
