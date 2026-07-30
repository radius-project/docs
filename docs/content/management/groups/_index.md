---
type: docs
title: "How to design and manage Resource Groups"
linkTitle: "Manage Resource Groups"
description: "Learn how to design a Resource Group layout and use Resource Groups with the Radius CLI"
weight: 100
aliases:
    - /guides/groups/
    - /guides/environments/groups/
    - /guides/environments/groups/overview/
    - /guides/environments/groups/howto-resourcegroups/
---

Resource Groups organize Radius resources into scopes that can be managed independently. They are analogous to, but distinct from, Kubernetes namespaces and Azure resource groups. Every Radius resource belongs to exactly one Resource Group. Today, Resource Groups only hold resources. In the future, Resource Groups will be extended to implement Radius role-based access controls.

This guide explains how to design a Resource Group layout, create a group, and target it with Radius CLI commands. For more background, see [Resource Groups in the Radius concepts documentation]({{< ref "concepts#resource-groups" >}}).

## Design a Resource Group layout

Use Resource Groups to collect resources that share a lifecycle, owner, or deployment boundary. Common layouts include:

- **Default Resource Group:** Keep all resources in the `default` Resource Group created upon Radius installation. This is the simplest layout for evaluating Radius, local development, or a small installation managed by one team. Create additional groups when resources need separate names, lifecycles, or ownership.
- **Environment-based:** Create separate groups such as `dev`, `test`, and `prod`. This lets applications use the same names in each deployment stage because each Resource Group provides a separate naming scope.
- **Application-based:** Create one group per application or service. This reduces naming conflicts and lets each application lifecycle remain independent.
- **Team-based:** Create groups for teams or business units. This works well when a team owns several applications and shared resources.

Choose a layout that keeps resources which are created, updated, and deleted together in the same group. Avoid putting every resource in one large group as the installation grows; broad groups increase the chance of naming collisions and make ownership less clear.

### Plan resource names

A resource name must be unique within its Resource Group and resource type. The Environment does not form part of the resource's naming scope. For example, a Resource Group cannot contain two `Radius.Core/applications` resources named `api`, even when one is deployed to the `dev` Environment and the other to `test`. The name `api` can be reused for a different resource type or in another Resource Group. See [Radius resource IDs]({{< ref "/reference/api/resource-ids#resource-name" >}}) for details.

If multiple Environments share a Resource Group, account for the Environment in the application definition. For example, parameterize the application name in Bicep:

```bicep
param environment string

// environment is a resource ID ending in /providers/Radius.Core/environments/{name}.
var environmentName = last(split(environment, '/'))

resource app 'Radius.Core/applications@2025-08-01-preview' = {
    name: 'api-${environmentName}'
    properties: {
        environment: environment
    }
}
```

Deploying to Environments named `dev` and `test` creates applications named `api-dev` and `api-test`. Alternatively, place each Environment's resources in a separate Resource Group so the application can be named `api` in both groups.

Use a consistent naming convention that identifies the owner or purpose of a resource. If several teams share a Resource Group, include an application or team identifier in names to prevent collisions.

### Radius Resource Groups and Azure resource groups

Radius Resource Groups and Azure resource groups are separate concepts:

- A **Radius Resource Group** organizes resources stored and managed by the Radius control plane, including applications, Environments, and Radius resource types.
- An **Azure resource group** organizes resources in an Azure subscription.

Creating a Radius Resource Group does not create an Azure resource group. The Azure subscription and resource group used for Azure deployments are configured through the Azure cloud provider on a Radius Environment. A Radius Resource Group and an Azure resource group can have different names and lifecycles.

## Create a Resource Group

Run [`rad group create`]({{< ref rad_group_create >}}) to create a group in the current Radius control plane:

```bash
rad group create myGroup
```

Confirm that the group exists with [`rad group show`]({{< ref rad_group_show >}}):

```bash
rad group show myGroup
```

## Target the Resource Group

Pass `--group` (or `-g`) to run a command against a specific Resource Group. For example, deploy `app.bicep` into `myGroup`:

```bash
rad deploy app.bicep --group myGroup
```

The flag is also available on other group-scoped commands. For example, list resources in `myGroup`:

```bash
rad resource list --group myGroup
```

Specifying `--group` makes the target explicit and is useful in scripts and automation.

## Delete a Resource Group

Run [`rad group delete`]({{< ref rad_group_delete >}}) when the group and all resources in it are no longer needed:

```bash
rad group delete myGroup
```

The command shows a confirmation prompt and deletes resources in the group before deleting the group. Review the resources carefully because this operation affects the entire Resource Group.

## Manage advanced layouts with Workspaces

For installations with multiple Resource Groups and Environments, use Workspaces to save the control plane, Resource Group, and Environment as a named target. See [How to manage Workspaces]({{< ref "/management/workspaces" >}}) to create and switch between targets without passing `--group` and `--environment` to every command.

## Next steps

Now that Resource Groups have been created, learn how to manage Environments.

{{< button text="Next step: How to manage Environments" page="/management/environments" >}}
