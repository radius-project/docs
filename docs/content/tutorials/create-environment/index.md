---
type: docs
title: "4. Create Environment"
linkTitle: "4. Create Environment"
description: "Create a Radius Environment to deploy the Application"
weight: 400
---

In part four of this tutorial, you will:

  - Create a Resource Group to contain all your resources
  - Create an Environment that uses the Recipe for the PostgreSQL Resource Type
  - Create a Workspace to configure the local Radius CLI

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

## Create an Environment

Radius Environments define where to deploy resources and what Recipes to use during deployment.

Create an Environment using the `rad environment create` command.

```bash
rad environment create my-env --group my-group
```

You should see output similar to: 

```
Creating Environment...
Successfully created environment "my-env" in resource group "my-group"
```

Inspect the Environment using the `rad environment show`

```bash
rad environment show my-env --output json
```

You should see output similar to: 

```
{
"id": "/planes/radius/local/resourcegroups/my-group/providers/Applications.Core/environments/my-env",
  "location": "global",
  "name": "my-env",
  "properties": {
    "compute": {
      "kind": "kubernetes",
      "namespace": "my-env"
    },
    "provisioningState": "Succeeded"
  }...
  "type": "Applications.Core/environments"
}
```

## Create a Workspace

A Radius Workspace is a set of configurations for the local Radius CLI. It is a combination of a Kubernetes context, a Radius Environment, and a Resource Group.

Create a new Workspace using the `rad workspace create` command.

  ```bash
  rad workspace create kubernetes my-workspace \
  --context $(kubectl config current-context) \
  --environment my-env \
  --group my-group 
  ```

  You should see output similar to: 

  ```
  Creating workspace...
  Set "my-workspace" as current workspace.
  ```

  Show the current workspace. The `--output json` will show the details of the workspace created.

  ```bash
  rad workspace show --output json
  ```
  
  You should see output similar to: 

  ```  
  {
    "connection": {
      "context": "k3d-k3s-default",
      "kind": "kubernetes"
    },
    "environment": "/planes/radius/local/resourceGroups/my-group/providers/applications.core/environments/my-env",
    "scope": "/planes/radius/local/resourceGroups/my-group"
  }
  ```

You can also view the workspace by inspecting the contents of `~/.rad/config.yaml`. 


## Update the Environment with the Recipe

Update the Environment with Terraform or Bicep Recipe based on your preference.

{{< tabs Terraform Bicep >}}{{% codetab %}}

```bash
  rad recipe register default \
    --environment my-env \
    --resource-type Radius.Data/postgreSqlDatabases \
    --template-kind terraform \
    --template-path git::https://github.com/radius-project/resource-types-contrib.git//Data/postgreSqlDatabases/recipes/kubernetes/terraform
```

You should see output similar to: 

```
Successfully linked recipe "default" to environment "my-env"
```

Verify the Recipe is registered using the `rad recipe list` command.

```bash
rad recipe list
```

You should see output similar to: 

```
RECIPE    TYPE                             TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
...
default   Radius.Data/postgreSqlDatabases  terraform                       git::https://github.com/radius-project/resource-types-contrib.git//Data/postgreSqlDatabases/recipes/kubernetes/terraform
```
{{% /codetab %}}
{{% codetab %}}

 ```bash
  rad recipe register default \
    --environment my-env \
    --resource-type Radius.Data/postgreSqlDatabases \
    --template-kind bicep \
    --template-path ghcr.io/radius-project/recipes/kubernetes/postgresql:0.53.0
```

You should see output similar to: 
```
Successfully linked recipe "default" to environment "my-env"
```

Verify the Recipe is registered using the `rad recipe list` command. 

```bash
rad recipe list
```

You should see output similar to:

```
RECIPE    TYPE                             TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
...
default   Radius.Data/postgreSqlDatabases  bicep                           ghcr.io/radius-project/recipes/kubernetes/postgresql:0.53.0
```
{{% /codetab %}}
{{< /tabs >}}

In the final part, you will deploy the Todo List application to the Environment you just created.
<br><br>
{{< button text="Next Step: Deploy Application" page="deploy-application" color="primary" >}}
