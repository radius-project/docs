---
type: docs
title: "Resource groups"
linkTitle: "Resource groups"
description: "Manage collections of resources with resource groups"
weight: 100
---

Resource groups are collections of resources that you can manage as a single unit. You can use resource groups to organize your resources when deploying Radius applications.

<img src="group-diagram.png" alt="Diagram showing Radius resources inside of a Radius resource group" width=600px />

{{% alert title="Radius vs. Azure Resource Groups" color="primary" %}}
Note that resource groups in Radius are not the same as [Azure resource groups](https://learn.microsoft.com/azure/azure-resource-manager/management/manage-resource-groups-portal). Azure resource groups are used to organize Azure resources, while Radius resource groups are used to organize Radius resources, such as applications, environments, links, and routes. When you deploy a template that contains both, Radius resources route to the Radius resource group defined in your workspace, and Azure resources route to the Azure resource group defined in your [cloud provider]({{< ref providers >}}).
{{% /alert %}}

## Initialization

As part of `rad init`, a default resource group is created for you, with the same name as your environment. This resource group is set as the default 'scope' of your [workspace]({{< ref workspaces >}}), so that all Radius resources you deploy will be created in this resource group.

## Manage groups with rad CLI

The rad CLI provides commands for managing resource groups. You can use the [`rad group`]({{< ref rad_group >}}) commands to create, list, and delete groups:

{{< tabs create list show delete switch >}}

{{% codetab %}}
[rad group create]({{< ref rad_group_create >}}) creates a new resource group:

```bash
rad group create myrg
```
{{% /codetab %}}

{{% codetab %}}
[rad group list]({{< ref rad_group_list >}}) lists all of the resource groups in your Radius installation:

```bash
rad group list
```
{{% /codetab %}}

{{% codetab %}}
[rad group show]({{< ref rad_group_show >}}) prints information on a resource group:

```bash
rad group show
```
{{% /codetab %}}

{{% codetab %}}
[rad group delete]({{< ref rad_group_delete >}}) deletes the specified resource group:

```bash
rad group delete -e mygroup
```
{{% /codetab %}}

{{% codetab %}}
[rad group switch]({{< ref rad_group_switch >}}) switches the default resource group in your [workspace]({{< ref workspaces >}}):

```bash
rad group switch mygroup
```
{{% /codetab %}}

{{< /tabs >}}

## Additional information

- [Radius API]({{< ref api-concept >}})
- [Radius architecture]({{< ref architecture-concept >}})
- [rad CLI reference]({{< ref rad_group >}})