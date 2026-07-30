---
type: docs
title: "Radius.Core/terraformSettings@2025-08-01-preview"
linkTitle: "TerraformSettings"
---

{{< schemaExample >}}

## Description

The `Radius.Core/terraformSettings` Resource Type holds reusable Terraform CLI settings that Environments apply when running Terraform Recipes. Its primary use is authenticating to private Terraform registries that host the modules referenced by a Recipe Pack, along with configuring provider installation and injecting environment variables during Recipe execution.

Platform engineers define a `Radius.Core/terraformSettings` resource once and reference it from any Environment whose Recipes pull modules from a private registry.

### Defining Terraform settings

Configure `terraformrc.credentials`, keyed by registry hostname, to authenticate to a private Terraform registry. Each entry points to a secret whose `token` key holds the registry token:

```bicep
extension radius

@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string

resource registrySecret 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'terraform-registry-token'
  properties: {
    environment: environment
    data: {
      token: { value: 'my-registry-token' }
    }
  }
}

resource terraformRegistry 'Radius.Core/terraformSettings@2025-08-01-preview' = {
  name: 'private-registry'
  properties: {
    terraformrc: {
      credentials: {
        'app.terraform.io': {
          secret: registrySecret.id
        }
      }
    }
  }
}
```

Two other settings are available: provider installation and environment variables.

### Provider installation

In air-gapped or internal environments, use `terraformrc.providerInstallation` to install providers from a network mirror instead of the public registry. Set the mirror `url`, optionally narrow it with `include` or `exclude` provider address patterns, and use `direct` to control which providers are still downloaded directly:

```bicep
resource providerMirror 'Radius.Core/terraformSettings@2025-08-01-preview' = {
  name: 'internal-mirror'
  properties: {
    terraformrc: {
      providerInstallation: {
        networkMirror: {
          url: 'https://terraform.corp.example.com/providers/'
          include: ['*']
        }
        direct: {
          exclude: ['*']
        }
      }
    }
  }
}
```

### Environment variables

Use `env` to inject environment variables into every Terraform Recipe run, for example to raise the Terraform log level for troubleshooting or to tune CLI behavior:

```bicep
resource terraformLogging 'Radius.Core/terraformSettings@2025-08-01-preview' = {
  name: 'terraform-logging'
  properties: {
    env: {
      TF_LOG: 'TRACE'
      TF_REGISTRY_CLIENT_TIMEOUT: '15'
    }
  }
}
```

### Deploying Terraform settings

Deploy the settings resource with the `rad deploy` command:

```bash
rad deploy ./terraform-settings.bicep
```

### Referencing Terraform settings from an Environment

Reference the settings from an Environment by setting its `terraformSettings` property to the resource ID. Every Terraform Recipe run in that Environment then uses the configured registry credentials:

```bicep
extension radius

resource terraformRegistry 'Radius.Core/terraformSettings@2025-08-01-preview' existing = {
  name: 'private-registry'
}

resource myEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'my-environment'
  properties: {
    terraformSettings: terraformRegistry.id
  }
}
```

For more information, see the Radius documentation at https://docs.radapp.io.

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `env` | object | (Optional) Environment variables injected into the Terraform process during Recipe execution. |
| `provisioningState` | string | (Read Only) The status of the Terraform settings resource within the Radius control plane.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `referencedBy` | string array | (Read Only) Resource IDs of the Environments that reference this Terraform settings resource. |
| `terraformrc` | [object](#terraformrc) | (Optional) Settings for the Terraform CLI configuration file. Radius renders these into a `.terraformrc` file used when running Terraform Recipes. |

## Object Properties

### `terraformrc` {#terraformrc}

| Property | Type | Description |
|----------|------|-------------|
| `credentials` | [object](#terraformrc-credentials) | (Optional) Credentials for authenticating to private Terraform registries such as `app.terraform.io`. Maps a registry hostname to its credential configuration. This authenticates to Terraform CLI registries over HTTP and does not authenticate Git-based module sources, which use a separate mechanism. |
| `providerInstallation` | [object](#terraformrc-providerinstallation) | (Optional) Controls where Terraform installs providers from, such as a network mirror instead of the public registry. |

### `terraformrc.credentials` {#terraformrc-credentials}

| Property | Type | Description |
|----------|------|-------------|
| `secret` | string | (Optional) The ID of a `Radius.Security/secrets` resource containing the authentication token. The secret must have a key named `token`. |

### `terraformrc.providerInstallation` {#terraformrc-providerinstallation}

| Property | Type | Description |
|----------|------|-------------|
| `direct` | [object](#terraformrc-providerinstallation-direct) | (Optional) Providers to install directly from the public registry rather than a mirror. |
| `networkMirror` | [object](#terraformrc-providerinstallation-networkmirror) | (Optional) A network mirror to install providers from instead of the public registry. |

### `terraformrc.providerInstallation.direct` {#terraformrc-providerinstallation-direct}

| Property | Type | Description |
|----------|------|-------------|
| `exclude` | string array | (Optional) Provider address patterns to exclude from direct installation. |
| `include` | string array | (Optional) Provider address patterns to include for direct installation. |

### `terraformrc.providerInstallation.networkMirror` {#terraformrc-providerinstallation-networkmirror}

| Property | Type | Description |
|----------|------|-------------|
| `exclude` | string array | (Optional) Provider address patterns to exclude from this mirror. |
| `include` | string array | (Optional) Provider address patterns to include from this mirror. |
| `url` | string | (Optional) The URL of the provider mirror. |
