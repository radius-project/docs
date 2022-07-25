---
type: docs
title: "Resource schemas"
linkTitle: "Resource schemas"
description: "Schema docs for the resources that can comprise a Radius application"
weight: 300
---

## Common values

The following properties and values are available across all Radius resources:

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. | `mycontainer`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`

### Name

The name of the resource defines how to address the resource within the context of the application.

#### Naming constraints

The current limitations of resource names are:

- Contain at most 63 user-entered characters
- Contain only alphanumeric characters or '-'
- Start with an alphabetic character
- End with an alphanumeric character

#### Rendered names

The combination of the resource name and application name results in the rendered resource name in a self-hosted Kubernetes environment. The resource group name and resource name also result in the full Universal Control Plane (UCP) identifier of the resource.

For example, take the following values:

- **Resource name:** `mycontainer`
- **Application name:** `myapp`
- **Resource group name:** `myrg`

The resulting names are:

- **Rendered Kubernetes pod name:** `myapp-mycontainer`
- **Universal Control Plane (UCP) ID:** `/planes/local/resourcegroups/myrg/providers/Applications.Core/containers/mycontainer`

### Location

## Resource categories
