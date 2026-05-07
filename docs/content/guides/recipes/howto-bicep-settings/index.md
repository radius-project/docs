---
type: docs
title: "How-To: Configure Bicep with BicepSettings"
linkTitle: "BicepSettings (private Bicep registries)"
description: "Use the BicepSettings resource to authenticate Radius to a private OCI registry hosting Bicep Recipes"
weight: 510
categories: "How-To"
tags: ["recipes", "bicep", "extensibility"]
---

`Radius.Core/bicepSettings` is the resource that holds Bicep-related configuration for Radius — most importantly, authentication for private OCI registries that host your Bicep Recipes. It is the [compute extensibility]({{< ref "concepts/compute-extensibility" >}}) replacement for the legacy `Environment.properties.recipeConfig.bicep.authentication` property.

> **Preview API:** BicepSettings uses the `2025-08-01-preview` API version. The schema may change as the feature is finalized. The legacy [`recipeConfig` private Bicep registry guide]({{< ref "howto-private-bicep-registry" >}}) still applies for environments that have not yet migrated.

## When to use this guide

Use BicepSettings when you store your Bicep Recipe templates in a private registry such as:

- Azure Container Registry (ACR)
- Amazon Elastic Container Registry (ECR)
- GitHub Container Registry (GHCR)
- Any OCI-compliant registry that requires authentication

If your Recipes live in an anonymous public registry, no BicepSettings resource is required.

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius initialized with `rad init`]({{< ref howto-environment >}})
- A private OCI registry with at least one Bicep Recipe published to it
- Credentials for that registry

## Supported authentication methods

| Method     | Property                | Use for                                                |
|------------|-------------------------|--------------------------------------------------------|
| `BasicAuth`| `basicAuthSecretId`     | Any OCI-compliant registry (Docker Hub, GHCR, etc.)    |
| `AzureWI`  | `azureWiClientId`, `azureWiTenantId` | Azure Container Registry via workload identity |
| `AwsIrsa`  | `awsIamRoleArn`         | Amazon ECR via IRSA                                    |

## Step 1: Create a Secret with the registry credentials

For `BasicAuth`, the Secret must have `username` and `password` keys:

```bicep
resource bicepRegistrySecret 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'bicepRegistrySecret'
  properties: {
    data: {
      username: {
        value: '<username>'
      }
      password: {
        value: '<password>'
      }
    }
  }
}
```

For `AzureWI` and `AwsIrsa` no Secret is required — the workload-identity client/tenant IDs and the IAM role ARN are not secrets.

## Step 2: Create the BicepSettings resource

```bicep
resource myBicepSettings 'Radius.Core/bicepSettings@2025-08-01-preview' = {
  name: 'myBicepSettings'
  properties: {
    registryAuthentication: {
      authenticationMethod: 'BasicAuth'
      basicAuthSecretId: bicepRegistrySecret.id
    }
  }
}
```

ACR with workload identity:

```bicep
resource myBicepSettings 'Radius.Core/bicepSettings@2025-08-01-preview' = {
  name: 'myBicepSettings'
  properties: {
    registryAuthentication: {
      authenticationMethod: 'AzureWI'
      azureWiClientId: '12345678-abcd-efgh-ijkl-9876543210ab'
      azureWiTenantId: '12345678-abcd-efgh-ijkl-9876543210ab'
    }
  }
}
```

ECR with IRSA:

```bicep
resource myBicepSettings 'Radius.Core/bicepSettings@2025-08-01-preview' = {
  name: 'myBicepSettings'
  properties: {
    registryAuthentication: {
      authenticationMethod: 'AwsIrsa'
      awsIamRoleArn: 'arn:aws:iam::012345678901:role/radius-ecr-pull'
    }
  }
}
```

## Step 3: Reference BicepSettings from your Environment

```bicep
resource myEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'myEnvironment'
  properties: {
    recipePacks: [myRecipePack.id]
    bicepSettings: myBicepSettings.id
  }
}
```

## Step 4: Deploy

```bash
rad deploy ./environment.bicep --group myGroup
```

When Radius next executes a Bicep Recipe whose `recipeLocation` resolves to your private registry, the Application RP authenticates using the credentials referenced by the BicepSettings resource.

## Migrating from `recipeConfig.bicep.authentication`

The legacy form embedded the registry-to-secret mapping inside the Environment:

```bicep
// Legacy
properties: {
  recipeConfig: {
    bicep: {
      authentication: {
        '<registry-host>': {
          secret: registrySecrets.id
        }
      }
    }
  }
}
```

In the new model, the same information lives in a standalone BicepSettings resource and the Environment simply references it. See the [migration guide]({{< ref "guides/operations/migration" >}}) for full before/after examples.

## Further reading

- [Compute extensibility concepts]({{< ref "concepts/compute-extensibility" >}})
- [Recipe Packs how-to]({{< ref "guides/recipes/recipe-packs" >}})
- [TerraformSettings how-to]({{< ref "guides/recipes/howto-terraform-settings" >}})
- [Migration guide]({{< ref "guides/operations/migration" >}})
