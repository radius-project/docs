---
type: docs
title: Radius Resource IDs
linkTitle: Resource IDs
description: Learn about the structure of Resource IDs
---

## Overview

Each resource in Radius has a unique identifier called a resource ID. Resource IDs have a common structure that allows resources to reference one-another. Resource IDs also map directly to the URLs used for a resource's lifecycle operations which is convenient for navigating the API.

The common structure of a resource ID is:

```txt
{rootScope}/providers/{resourceNamespace}/{resourceType}/{resourceName}
```

### Root scope

A hierarchical set of key-value pairs that identify the origin of the resource. Root scopes answer questions like:

- *"What cloud is this resource from?"*
- *"What cloud account contains this resource?"*
- *"What Kubernetes cluster is running this Pod?"*.

### Resource namespace and resource type

The namespace and type of a resource. These are defined together because resource types are usually two segments - a vendor namespace and a type name.

### Resource name

The name of the resource.

### Examples

This example shows a Radius Application named `my-app` in the `my-group` resource group, running on the local cluster:

| Key                | Example                                                                                        |
| ------------------ | ---------------------------------------------------------------------------------------------- |
| **Root scope**     | `/planes/radius/local/resourceGroups/my-group`                                                 |
| **Namespace/Type** | `Applications.Core/applications`                                                               |
| **Name**           | `my-app`                                                                                       |
| **Resource ID**    | `/planes/radius/local/resourceGroups/my-group/providers/Applications.Core/applications/my-app` |
