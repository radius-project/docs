---
type: docs
title: "3. Create Environment"
linkTitle: "3. Create Environment"
description: "Create a Radius Environment to deploy the application"
weight: 400
---

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
{{< button text="Next Step: Create Recipe" page="create-recipe" color="primary" >}}