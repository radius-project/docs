---
type: docs
title: "Radius.Core/bicepSettings@2025-08-01-preview"
linkTitle: "BicepSettings"
---

{{< schemaExample >}}

## Description

The `Radius.Core/bicepSettings` Resource Type holds reusable Bicep engine settings that Environments apply when running Bicep Recipes. Its primary use is authenticating to private Bicep registries: OCI registries, such as Azure Container Registry, that host the Recipe templates referenced by a Recipe Pack.

Platform engineers define a `Radius.Core/bicepSettings` resource once and reference it from any Environment whose Recipes pull templates from a private registry.

### Defining Bicep settings

Configure `registryAuthentications`, keyed by registry hostname. When a Recipe template is pulled from a matching host, Radius authenticates using the configured method. The example below uses basic authentication, reading the username and password from a secret:

```bicep
extension radius

@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string

resource registrySecret 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'registry-credentials'
  properties: {
    environment: environment
    data: {
      username: { value: 'my-username' }
      password: { value: 'my-password' }
    }
  }
}

resource bicepRegistry 'Radius.Core/bicepSettings@2025-08-01-preview' = {
  name: 'private-registry'
  properties: {
    registryAuthentications: {
      'corp.azurecr.io': {
        authenticationMethod: 'BasicAuth'
        basicAuthSecretId: registrySecret.id
      }
    }
  }
}
```

Basic authentication is supported via `BasicAuth` (username and password from a secret). `AwsIrsa` and `AzureWI` will be implemented in the future.

### Deploying Bicep settings

Deploy the settings resource with the `rad deploy` command:

```bash
rad deploy ./bicep-settings.bicep
```

### Referencing Bicep settings from an Environment

Reference the settings from an Environment by setting its `bicepSettings` property to the resource ID. Every Bicep Recipe run in that Environment then uses the configured registry authentication:

```bicep
extension radius

resource bicepRegistry 'Radius.Core/bicepSettings@2025-08-01-preview' existing = {
  name: 'private-registry'
}

resource myEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'my-environment'
  properties: {
    bicepSettings: bicepRegistry.id
  }
}
```

For more information, see the Radius documentation at https://docs.radapp.io.

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `provisioningState` | string | (Read Only) The status of the Bicep settings resource within the Radius control plane.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `referencedBy` | string array | (Read Only) Resource IDs of the Environments that reference this Bicep settings resource. |
| `registryAuthentications` | [object](#registryauthentications) | (Optional) Authentication for private Bicep registries that host Recipe templates, keyed by registry hostname such as `corp.acr.io`. Radius matches a registry by the hostname in the Recipe source. |

## Object Properties

### `registryAuthentications` {#registryauthentications}

| Property | Type | Description |
|----------|------|-------------|
| `authenticationMethod` | string | (Optional) How Radius authenticates to the registry.<br />Allowed values: `AwsIrsa`, `AzureWI`, `BasicAuth`. |
| `awsIamRoleArn` | string | (Optional) AWS IAM Role ARN for IRSA authentication. Required when `authenticationMethod` is `AwsIrsa`. |
| `azureWiClientId` | string | (Optional) Azure Workload Identity client ID. Required when `authenticationMethod` is `AzureWI`. |
| `azureWiTenantId` | string | (Optional) Azure Workload Identity tenant ID. Required when `authenticationMethod` is `AzureWI`. |
| `basicAuthSecretId` | string | (Optional) The ID of a `Radius.Security/secrets` resource containing the username and password. Required when `authenticationMethod` is `BasicAuth`. |
