---
type: docs
title: "Radius Configuration file"
linkTitle: "config.yaml"
description: "Detailed reference documentation on the Radius config.yaml configuration file"
weight: 500
---

Radius [workspaces]({{< ref workspaces >}}) are used to easily switch between environments.

```yaml
workspaces:
  default: dev
  items:
    dev:
      connection:
        context: DevCluster
        kind: kubernetes
      environment: /planes/radius/local/resourcegroups/dev/providers/applications.core/environments/dev
      scope: /planes/radius/local/resourceGroups/dev
      providerConfig:
        azure:
          subscriptionid: DEV-SUBID
          resourcegroup: Dev
    prod:
      connection:
        context: ProdCluster
        kind: kubernetes
      environment: /planes/radius/local/resourcegroups/prod/providers/applications.core/environments/prod
      scope: /planes/radius/local/resourceGroups/prod
      providerConfig:
        azure:
          subscriptionid: PROD-SUBID
          resourcegroup: Prod
```

## Default location

- **macOS/Linux:** `~/.radius/config.yaml`
- **Windows:** `%USERPROFILE%\.radius\config.yaml`

## Schema

### workspaces

| Key | Description | Example |
|-----|-------------|---------|
| **default** | The name of the default workspace to use with rad CLI commands | `dev` |
| [**items**](#items) | A list of workspaces |

#### items

| Key | Description | Example |
|-----|-------------|---------|
| **[workspace-name]** | The name of the workspace. Used as the key for the list entry. | `dev` |
| [**connection**](#connection) | The connection details for the target Radius platform | |
| **environment** | The default environment UCP ID to use for the workspace. Can be empty if no environment exists or if no default set | `/planes/radius/local/resourcegroups/dev/providers/applications.core/environments/dev` |
| **scope** | The default scope UCP ID to use for the workspace | `/planes/radius/local/resourcegroups/dev` |
| [**providerConfig**](#providerconfig) | The provider configuration for the workspace | |

#### connection

| Key | Description | Example |
|-----|-------------|---------|
| **context** | The name of the Kubernetes context to use | `DevCluster` |
| **namespace** | The name of the Kubernetes namespace to use when deploying Radius applications | `default` |

#### providerConfig

| Key | Description | Example |
|-----|-------------|---------|
| **azure** | The kind of [cloud provider](#cloud-providers) to configure. Currently only 'azure' is supported | `azure` |
| **subscirptionid** | The Azure subscriptionID to deploy resources into
| **resourcegroup** | The name of the Azure resource group to deploy Azure resources into | `Dev` |
