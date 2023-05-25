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
| location | n | The location of your resource. See [below](#location) for more information. Defaults to 'global' for Radius resources. | `global`
| environment | y | The environment used by your resources for deployment. | `environment` |

### Name

The name of the resource defines how to address the resource within the context of the application.

#### Naming constraints

Radius resource names follow the DNS-1035 naming convention. This, plus other control-plane requirements, result in resource names that must:

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

The location property defines where to deploy a resource within the targeted platform.

For self-hosted environments, the location property is defaulted to `global` to indicate the resource is scoped to the entire underlying cluster. This is a point-in-time implementation that will be revisited in a future revision of self-hosted Kubernetes environments.

### Environment parameter

The `environment` string parameter is automatically injected into your Bicep template using the environment ID value specified in your default [workspace]({{< ref workspaces >}}). This value can also be overridden with the rad CLI: `rad deploy --params environment="/planes/radius/..."`.

To access the auto-injected value, specify an `environment` string parameter in your Bicep file:

```bicep
param environment string
```

## Resource categories
