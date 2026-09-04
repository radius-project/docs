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

Begin with the Radius Demo `app.bicep` from [How to model application resources]({{< ref "/applications/definitions" >}}). It declares a `demoApp` Application and a `demoContainer` Container. The target Environment's Recipe Packs must contain a recipe for each Resource Type the definition uses.

## Step 2: Deploy to an Environment

Deploy the application definition from its published URL to an Environment with [`rad deploy`]({{< ref rad_deploy >}}):

{{< rad-deploy path="samples/demo/app.bicep" >}}

Radius compiles the Bicep file, supplies the Environment configured in the current Workspace through the `environment` parameter, and creates or updates the Application and its resources.

Use `--environment` to deploy to a different Environment:

{{< rad-deploy path="samples/demo/app.bicep" args="--environment dev" >}}

After the deployment succeeds, inspect the Application graph:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application graph --application demo-default --preview
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
rad application status demo-default --preview --output json
rad application graph --application demo-default --preview --output json
```

If a recipe creates Kubernetes resources, inspect the target namespace for failed workloads and events:

```bash
kubectl get pods --namespace <namespace>
kubectl get events --namespace <namespace> --sort-by=.lastTimestamp
```

The Kubernetes namespace is configured on the Environment and may differ from the Environment name. See [How to design and manage Environments]({{< ref "/management/environments" >}}) to inspect Environment configuration.

## Prune removed resources

Removing a resource declaration from your definition and deploying the file again does not delete the existing resource. This prevents an accidental deletion when a declaration is removed or renamed.

For example, if you added the `redis` cache in [How to model application dependencies using connections]({{< ref "/applications/connections" >}}), redeploy the original `app.bicep`, which does not declare the cache or its connection:

{{< rad-deploy path="samples/demo/app.bicep" >}}

Radius leaves the existing `redis-default` cache in place because its declaration is gone. List the Application's resources to confirm:

```bash
rad resource list --application demo-default
```

Delete the removed resource by its Resource Type and name:

```bash
rad resource delete Radius.Data/redisCaches redis-default
```

The command prompts for confirmation, deletes the Radius resource, and runs its normal deletion lifecycle for infrastructure managed by that resource.

Review the resource before confirming deletion. Deleting a database, message broker, or other stateful resource can permanently delete its managed infrastructure and data.

Confirm that the removed resource no longer appears in the Application graph:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application graph --application demo-default --preview
```

## Delete an Application

Delete an Application when it and all of its owned resources are no longer needed:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application delete demo-default --preview
```

The command prompts for confirmation. Radius finds resources whose `application` property references `demo-default`, deletes them, and then deletes the Application resource. Resources that are shared with or connected to the Application but are not owned by it are not deleted.

Deleting an Application can permanently delete managed infrastructure and data. Review the Application graph before confirming the operation. Use `--yes` to bypass confirmation in automation.

Use `--force` only when the Application contains resources stuck in a non-terminal state. Force deletion can leave external infrastructure behind for manual cleanup.
