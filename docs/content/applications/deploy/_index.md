---
type: docs
title: "How to deploy applications using Radius"
linkTitle: "Deploy applications"
description: "Learn how to deploy and manage applications with Radius"
weight: 300
aliases:
  - /guides/applications/
---

An [Application]({{< ref "/concepts/applications" >}}) in Radius groups the resources that make up an application and records the relationships between them. You define an Application and its resources in Bicep, then deploy the definition to a Radius Environment.

## Step 1: Create an application definition

Create a file named `app.bicep`. Import the Radius extension and declare an `environment` parameter. The Radius CLI supplies the selected Environment's resource ID when you deploy the file.

Define a `Radius.Core/applications` resource, then add the resources that make up the Application. Set `environment` and `application` on each resource to associate it with the Application:

```bicep
extension radius

@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string

resource app 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'my-app'
  properties: {
    environment: environment
  }
}

resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    environment: environment
    application: app.id
    containers: {
      web: {
        image: 'ghcr.io/radius-project/samples/demo:latest'
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
    }
  }
}
```

Use any Resource Type installed in your Radius control plane. Review the [Resource Types reference]({{< ref "/reference/resources" >}}) for the available properties and examples. The Environment's Recipe Packs must contain a recipe for each Resource Type used by the Application.

## Step 2: Deploy to an Environment

Deploy the application definition to an Environment with [`rad deploy`]({{< ref rad_deploy >}}):

```bash
rad deploy app.bicep
```

Radius compiles the Bicep file, supplies the Environment configured in the current Workspace through the `environment` parameter, and creates or updates the Application and its resources.

Use `--environment` to deploy to a different Environment:

```bash
rad deploy app.bicep --environment dev
```

After the deployment succeeds, inspect the Application graph:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application graph --application my-app --preview
```

The graph shows the Radius resources, infrastructure created by recipes, and relationships between resources.

## Troubleshoot deployment errors

Start with the error returned by `rad deploy`. Errors generally occur in one of three stages:

- **Bicep compilation:** Correct Bicep syntax, resource type versions, property names, and parameter values. Use the [Resource Types reference]({{< ref "/reference/resources" >}}) to verify the schema.
- **Radius resource deployment:** Confirm that the target Environment exists and that every resource sets the expected `environment` and `application` properties. Inspect the Application with `rad application status` and `rad application graph`.
- **Recipe execution:** Confirm that the Environment uses a Recipe Pack containing a recipe for the failing Resource Type. Review the recipe source, parameters, cloud provider configuration, and credentials.

Use JSON output when you need the complete resource details:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application status my-app --preview --output json
rad application graph --application my-app --preview --output json
```

If a recipe creates Kubernetes resources, inspect the target namespace for failed workloads and events:

```bash
kubectl get pods --namespace <namespace>
kubectl get events --namespace <namespace> --sort-by=.lastTimestamp
```

The Kubernetes namespace is configured on the Environment and may differ from the Environment name. See [How to design and manage Environments]({{< ref "/management/environments" >}}) to inspect Environment configuration.

## Prune removed resources

Removing a resource declaration from `app.bicep` and deploying the file again does not delete the existing resource. This prevents an accidental deletion when a declaration is removed or renamed.

After removing the declaration, deploy the updated Application:

```bash
rad deploy app.bicep
```

List the resources that still belong to the Application:

```bash
rad resource list --application my-app
```

Delete the removed resource by its Resource Type and name. For example, delete the `frontend` Container:

```bash
rad resource delete Radius.Compute/containers frontend
```

The command prompts for confirmation, deletes the Radius resource, and runs its normal deletion lifecycle for infrastructure managed by that resource.

Review the resource before confirming deletion. Deleting a database, message broker, or other stateful resource can permanently delete its managed infrastructure and data.

Confirm that the removed resource no longer appears in the Application graph:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application graph --application my-app --preview
```

## Delete an Application

Delete an Application when it and all of its owned resources are no longer needed:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application delete my-app --preview
```

The command prompts for confirmation. Radius finds resources whose `application` property references `my-app`, deletes them, and then deletes the Application resource. Resources that are shared with or connected to the Application but are not owned by it are not deleted.

Deleting an Application can permanently delete managed infrastructure and data. Review the Application graph before confirming the operation. Use `--yes` to bypass confirmation in automation.

Use `--force` only when the Application contains resources stuck in a non-terminal state. Force deletion can leave external infrastructure behind for manual cleanup.
