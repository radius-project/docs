---
type: docs
title: Radius Resource IDs
linkTitle: Resource IDs
description: Learn about the structure of Resource IDs
weight: 100
---

Each resource in Radius has a unique identifier called a resource ID. Resource IDs have a common structure that allows resources to reference one another. Resource IDs also map directly to the URLs used for a resource's lifecycle operations, which is convenient for navigating the API.

The common structure of a resource ID is:

```txt
{rootScope}/providers/{resourceNamespace}/{resourceType}/{resourceName}
```

## Root scope

A hierarchical set of key-value pairs that identify the origin of the resource. Root scopes answer questions like:

- *"What cloud is this resource from?"*
- *"What cloud account contains this resource?"*
- *"What Kubernetes cluster is running this Pod?"*

For example, a resource in the `my-group` resource group on the local Radius plane has the root scope `/planes/radius/local/resourceGroups/my-group`.

## Resource namespace and resource type

A resource's type is written as two segments joined by a slash: a *namespace* and a *type name*. For example, in `Radius.Core/applications` the namespace is `Radius.Core` and the type name is `applications`.

The namespace groups related resource types under a common vendor or domain. For example, `Radius.Core` contains the core Radius types such as `applications` and `environments`, while `Radius.Data` contains data resource types such as `postgreSqlDatabases`. The type name identifies a specific kind of resource within that namespace.

Because the namespace and type name together identify a resource type, they always appear as a pair (`{resourceNamespace}/{resourceType}`) in a resource ID, immediately after the `providers` segment.

## Resource name

The final segment of a resource ID, identifying a specific resource instance within its type. A resource name is unique within a given root scope and resource type, so the same name can be reused across different types or resource groups. For example, an application named `my-app` has the resource name `my-app`.

## Example

Combining a root scope, a namespace and type, and a name produces a complete resource ID. For example, a Radius application named `my-app` in the `my-group` resource group on the local cluster has the following resource ID:

```txt
/planes/radius/local/resourceGroups/my-group/providers/Radius.Core/applications/my-app
```
