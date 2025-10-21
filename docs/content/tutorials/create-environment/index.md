---
type: docs
title: "4. Create Environment"
linkTitle: "4. Create Environment"
description: "Create a Radius Environment to deploy the application"
weight: 400
---

In part four of this tutorial, you will create an environment to register the Recipe for the PostgreSQL resource type.

## Create a workspace

Radius Workspace is a combination of a Kubernetes context, a Radius Environment, and a Resource Group.

Create a new workspace using the [`rad workspace create`]({{< ref rad_workspace_create >}}) command to manage the cluster configuration.

  ```bash
  rad workspace create kubernetes my-workspace
  ```

  ```
  Creating workspace...
  Set "my-workspace" as current workspace.
  ```

  Show the current workspace. The `--output json` will show the details of the workspace created.

  ```bash
  rad workspace show -o json   
  ```

  ```  
  {
    "connection": {
      "context": "my-kube-context",
      "kind": "kubernetes"
    }
  }
  ```

## Create a Radius Resource Group

Radius Resource group define the permission boundary for Radius resources.

Create a Radius Resource Group using the [`rad group create`]({{< ref rad_group_create >}}) command.

```bash
rad group create my-group
```
```
creating resource group "my-group" in workspace "my-workspace"...

resource group "my-group" created
```

## Create a Radius Environment

Radius Environment is the landing zone for Radius applications.

Create a Radius Environment using the [`rad environment create`]({{< ref rad_environment_create >}}) command.

```bash
rad environment create my-env --group my-group
```
```
Creating Environment...
Successfully created environment "my-env" in resource group "my-group"
```
Update the workspace with the group and environment

```bash
  rad workspace create kubernetes my-workspace \
  --context `kubectl config current-context` \
  --environment my-env \
  --group my-group --force
```


Inspect the Environment using the [`rad environment show`]({{< ref rad_environment_show >}}) commands.

```bash
rad environment show my-env --output json
```
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

## Register a Recipe

Register the Recipe as `default` in the environment `my-env` created in the previous step using the [`rad recipe register`]({{< ref rad_recipe_register >}}) command.

{{< tabs Terraform Bicep >}}{{% codetab %}}

```bash
  rad recipe register default \
    --environment my-env \
    --resource-type Radius.Data/postgreSqlDatabases \
    --template-kind terraform \
    --template-path git::https://github.com/radius-project/resource-types-contrib.git//Data/postgreSqlDatabases/recipes/kubernetes/terraform
```

The output will be:

```
Successfully linked recipe "default" to environment "my-env"
```

Verify the Recipe is registered using the [`rad recipe list`]({{< ref rad_recipe_list >}}) command.

```bash
rad recipe list
```

```
RECIPE    TYPE                             TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
...
default   Radius.Data/postgreSqlDatabases  terraform                       git::https://github.com/<github-user-name>/recipes.git//kubernetes/postgresql
```
{{% /codetab %}}
{{% codetab %}}

 ```bash
  rad recipe register default --environment my-env \
    --resource-type Radius.Data/postgreSqlDatabases \
    --template-kind bicep \
    --template-path <host>/<registry>/postgresql:latest
```

```
Successfully linked recipe "default" to environment "my-env"
```

Verify the Recipe is registered using the [`rad recipe list`]({{< ref rad_recipe_list >}}) command. You should see output similar to:

```bash
rad recipe list
```

```
RECIPE    TYPE                             TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
...
default   Radius.Data/postgreSqlDatabases  bicep                           <host>/<repository>/postgresql:latest
```
{{% /codetab %}}
{{< /tabs >}}

In the next part, you will deploy an application with the PostgreSQL resource that uses the Terraform or Bicep Recipe registered in the environment.
<br><br>
{{< button text="Next Step: Deploy Application" page="deploy-application" color="primary" >}}
