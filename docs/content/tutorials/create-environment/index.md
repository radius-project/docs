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
   $ rad workspace create my-workspace
   Creating workspace 'my-workspace'...
   Workspace 'my-workspace' created successfully.
   ```

   Show the current Workspace. The `--output json` will show all the details of the Workspace.

   ```bash
   rad workspace show -o json   
   ```

   ```
   $ rad workspace show -o json   
   {
     "connection": {
       "context": "my-kube-context",
       "kind": "kubernetes"
     },
     "environment": "/planes/radius/local/resourceGroups/default/providers/Applications.Core/environments/default",
     "scope": "/planes/radius/local/resourceGroups/default"
   }
   ```

   Notice that a 
   {{< alert title="💡 Workspaces" color="info" >}}
   [Workspaces]({{< ref Workspaces >}}) are configurations set for the Radius CLI. Similar to kubectl contexts, you can have multiple Workspaces pointing to different Radius installation, Resource Groups, and Environments.
   {{< /alert >}}


## Create a Radius Resource Group

Create a Radius Resource Group using the rad group create command. 

```bash
rad group create my-group
```

## Create a Radius Environment

Create a Radius Environment using the rad environment create command.

```bash
rad environment create my-env
```

Inspect the Environment using the [`rad environment show`]({{< ref rad_environment_show >}}) commands.

   ```bash
   rad environment show my-env --output json
   ```

   ```
   $ rad environment show my-env --output json
   {
     "id": "/planes/radius/local/resourcegroups/default/providers/Applications.Core/environments/my-env",
     "location": "global",
     "name": "my-env",
     "properties": {
       "compute": {
         "kind": "kubernetes",
         "namespace": "default"
       },
       "provisioningState": "Succeeded",
       "recipes": {
            ...
       }
     },
     ...
     "type": "Applications.Core/environments"
   }
   ```

## Register a Recipe

{{< tabs Terraform Bicep >}}{{% codetab %}}
Register the Terraform configuration as a Recipe called `default`. Since Recipes are registered with Environments, use the  `default` environment created in the previous tutorial.

    ```bash
    rad recipe register default \
      --environment default \
      --resource-type Radius.Resources/postgreSQL \
      --template-kind terraform \
      --template-path git::<git-server-name>/<repository-name>.git//<directory>/<subdirectory>
    ```

    For example, if the `main.tf` file is in a GitHub repository named `recipes` in a directory called `/kubernetes/postgresql`, the command would look like this:
    
    ```bash 
      --template-path git::https://github.com/<github-user-name>/recipes.git//kubernetes/postgresql
    ```

    The output will be:

    ```
    Successfully linked recipe "default" to environment "default"
    ```

1. Verify the Recipe is registered using the [`rad recipe list`]({{< ref rad_recipe_list >}}) command. 

    ```bash
    rad recipe list
    ```

    ```
    $ rad recipe list
    RECIPE    TYPE                         TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
    ...
    default   Radius.Resources/postgreSQL  terraform                       git::https://github.com/<github-user-name>/recipes.git//kubernetes/postgres
    ```
{{% /codetab %}}
{{% codetab %}}

1. Register the Bicep template as a Recipe called `default`. Since Recipes are registered with Environments, use the  `default` environment created in the previous tutorial.

    ```bash
    rad recipe register default --environment default \
      --resource-type Radius.Resources/postgreSQL \
      --template-kind bicep \
      --template-path <host>/<registry>/postgresql:latest
    ```

    ```
    Successfully linked recipe "default" to environment "default"
    ```

1. Verify the Recipe is registered using the [`rad recipe list`]({{< ref rad_recipe_list >}}) command. You should see output similar to:

   ```bash
   rad recipe list
   ```

    ```
    $ rad recipe list
    RECIPE    TYPE                         TEMPLATE KIND  TEMPLATE VERSION TEMPLATE
    ...
    default   Radius.Resources/postgreSQL  bicep                           <host>/<repository>/postgresql:latest
    ```
{{% /codetab %}}
{{< /tabs >}}

{{< button text="Next Step: Deploy Application" page="deploy-application" color="primary" >}}