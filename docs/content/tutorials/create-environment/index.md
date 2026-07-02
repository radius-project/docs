---
type: docs
title: "4. Create Environment"
linkTitle: "4. Create Environment"
description: "Create a Radius Environment to deploy the Application"
weight: 400
categories: "Tutorial"
---

In part four of this tutorial, you will:

  - Create a Resource Group to contain all your resources
  - Create a Workspace to configure the local Radius CLI
  - Create a Recipe Pack that bundles the PostgreSQL Recipe from part three
  - Create an Environment that attaches the Recipe Pack and targets your Kubernetes cluster

## Create a Resource Group

All resources, including Environments, are created within a Resource Group.

Create a Resource Group using the `rad group create`.

```bash
rad group create my-group
```
You should see output similar to: 

```
creating resource group "my-group" in workspace "my-workspace"...

resource group "my-group" created
```

## Create a Workspace

A Radius Workspace is a set of configurations for the local Radius CLI. It is a combination of a Kubernetes context, a Resource Group, and (later) a Radius Environment.

Create a new Workspace using the `rad workspace create` command.

```bash
rad workspace create kubernetes my-workspace \
  --context $(kubectl config current-context) \
  --group my-group
```

You should see output similar to: 

```
Creating workspace...
Set "my-workspace" as current workspace.
```

You can also view the workspace by inspecting the contents of `~/.rad/config.yaml`. 

## Create a Recipe Pack and Environment

A Recipe Pack is a collection of Recipes grouped by resource type. An Environment attaches one or more Recipe Packs and selects a target compute provider (such as Kubernetes). Both resources are defined together in a single Bicep file.

Create a file called `env.bicep` and add the contents below, choosing the tab for the IaC language you used in part three.

{{< tabs Terraform Bicep >}}{{% codetab %}}

{{% rad file="snippets/env-terraform.bicep" embed=true %}}

{{% /codetab %}}
{{% codetab %}}

{{% rad file="snippets/env-bicep.bicep" embed=true %}}

{{% /codetab %}}
{{< /tabs >}}

Deploy the Recipe Pack and Environment:

```bash
rad deploy env.bicep --group my-group
```

You should see output similar to:

```
Building env.bicep...
Deploying template 'env.bicep' for workspace 'my-workspace'...

Deployment In Progress... 

Completed            postgresqlPack       Radius.Core/recipePacks
Completed            my-env               Radius.Core/environments

Deployment Complete
```

Set the new Environment as the default for your Workspace so that `rad deploy` targets it automatically:

```bash
rad workspace update my-workspace --environment my-env
```

## Inspect the Environment and Recipe Pack

Inspect the Environment using `rad environment show`:

```bash
rad environment show my-env --group my-group --output json
```

You should see output similar to:

```json
{
  "id": "/planes/radius/local/resourcegroups/my-group/providers/Radius.Core/environments/my-env",
  "location": "global",
  "name": "my-env",
  "properties": {
    "providers": {
      "kubernetes": {
        "namespace": "my-env"
      }
    },
    "recipePacks": [
      "/planes/radius/local/resourcegroups/my-group/providers/Radius.Core/recipePacks/postgresqlPack"
    ],
    "provisioningState": "Succeeded"
  },
  "type": "Radius.Core/environments"
}
```

Inspect the Recipe Pack and the Recipes it contains using `rad recipe-pack show`:

```bash
rad recipe-pack show postgresqlPack --group my-group
```

In the final part, you will deploy the Todo List application to the Environment you just created.
<br><br>
{{< button text="Next Step: Deploy Application" page="deploy-application" color="primary" >}}
