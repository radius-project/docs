---
type: docs
title: "How-To: Configure Terraform with TerraformSettings"
linkTitle: "TerraformSettings (Terraform CLI, backend, and credentials)"
description: "Install, configure, and authenticate Terraform inside the Radius control plane using the TerraformSettings resource"
weight: 520
categories: "How-To"
tags: ["recipes", "terraform", "extensibility"]
---

`Radius.Core/terraformSettings` is the resource that holds the Terraform configuration used by Radius when it executes Terraform Recipes. It supersedes the various `Environment.properties.recipeConfig.terraform.*` properties from the legacy model. Together with the new `rad terraform install` command, it gives platform engineers full control over the Terraform binary, its CLI configuration (`terraformrc`), the Terraform backend, and provider authentication.

> **Preview API:** TerraformSettings uses the `2025-08-01-preview` API version. The schema and behaviour may evolve as the feature is finalized. The full feature spec is in [Terraform and Bicep Settings](https://github.com/radius-project/design-notes/blob/main/features/2025-08-14-terraform-bicep-settings.md).

## What changed

- Radius **no longer downloads Terraform on demand.** The platform engineer installs (and upgrades) Terraform explicitly with `rad terraform install`.
- Terraform CLI configuration, backend, environment variables, and provider mirrors are configured through a **TerraformSettings resource** that the Environment references — not through fields embedded in the Environment.
- Provider credentials that aren't AWS/Azure (for example Datadog, GitHub, Cloudflare) are injected by passing **Recipe parameters** that reference Radius `Secret` values instead of using the legacy `recipeConfig.terraform.providers` map.

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius initialized with `rad init`]({{< ref howto-environment >}})

## Step 1: Install Terraform into the Radius control plane

Quick install (latest from `releases.hashicorp.com`):

```bash
rad terraform install
```

Pinned install from a mirror with checksum validation:

```bash
rad terraform install \
  --url "https://<tf_mirror_url>/terraform_1.5.7_linux_amd64.zip" \
  --checksum "sha256:37f2d497ea512324d59b50ebf1b58a6fcc2a2828d638a4f6fdb1f41af00140f3"
```

Re-running `rad terraform install` upgrades or replaces the existing installation. Use `rad terraform uninstall` to remove it.

## Step 2: Author a TerraformSettings resource

A minimal TerraformSettings resource — useful when you only need to set environment variables or change the log level:

```bicep
resource myTerraformSettings 'Radius.Core/terraformSettings@2025-08-01-preview' = {
  name: 'myTerraformSettings'
  properties: {
    env: {
      TF_LOG: 'INFO'
      TF_REGISTRY_CLIENT_TIMEOUT: '15'
    }
  }
}
```

A richer example using a private provider mirror, registry credentials stored in a Secret, and an S3 backend:

```bicep
param mirrorToken string

resource providerSecret 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'tfProviderSecret'
  properties: {
    data: {
      token: {
        value: mirrorToken
      }
    }
  }
}

resource myTerraformSettings 'Radius.Core/terraformSettings@2025-08-01-preview' = {
  name: 'myTerraformSettings'
  properties: {
    terraformrc: {
      provider_installation: {
        network_mirror: {
          path: 'https://<tf_mirror_url>/'
          include: ['*']
        }
        direct: {
          exclude: ['azurerm']
        }
      }
      credentials: [
        {
          host: '<tf_mirror_url>'
          secret: providerSecret.id
        }
      ]
    }
    backend: {
      type: 's3'
      bucket: 'my-company-dev-tfstate-bucket'
      key: 'radius/terraform.tfstate'
      region: 'us-east-1'
      encrypt: 'true'
      dynamodb_table: 'terraform-global-locks'
    }
    env: {
      TF_LOG: 'TRACE'
    }
  }
}
```

### `terraformrc` properties supported by Radius

| Setting                                             | Supported |
|-----------------------------------------------------|-----------|
| `credentials`                                       | ✅        |
| `provider_installation`                             | ✅        |
| `credential_helper`                                 | ❌        |
| `disable_checkpoint` / `disable_checkpoint_signature` | ❌      |
| `plugin_cache_dir`                                  | ❌        |

Unsupported settings are not part of the resource schema; deployment will fail if they are specified.

### Backend types

Tier 1 backends (integrated authentication, tested by the Radius project): `kubernetes` (default), `s3`, `azurerm`.

Tier 2 backends (schema available, authentication BYO): `oss`, `consul`, `gcs`, `http`, `oci`, `pg`, `cos`.

The Terraform `local` and `remote` backends are not supported.

## Step 3: Reference TerraformSettings from your Environment

```bicep
resource myEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'myEnvironment'
  properties: {
    recipePacks: [myRecipePack.id]
    terraformSettings: myTerraformSettings.id
  }
}
```

Deploy:

```bash
rad deploy ./environment.bicep --group myGroup
```

## Step 4: Inject Secrets into custom Terraform providers

For providers other than AWS / Azure / Kubernetes, pass Recipe parameters that read from a Radius Secret:

```bicep
resource datadogCredentials 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'datadogCredentials'
  properties: {
    data: {
      apiKey: { value: '<datadog-api-key>' }
      appKey: { value: '<datadog-app-key>' }
    }
  }
}

resource observabilityRecipePack 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'observability'
  properties: {
    recipes: {
      'Radius.Observability/dashboard': {
        default: {
          recipeKind: 'terraform'
          recipeLocation: 'git::https://github.com/myorg/recipes//datadog?ref=v1.0.0'
          parameters: {
            apiKey: datadogCredentials.properties.data.apiKey.value
            appKey: datadogCredentials.properties.data.appKey.value
          }
        }
      }
    }
  }
}
```

Inside the Recipe itself, declare the corresponding `var`s and use them in the `provider` block.

## Migrating from `recipeConfig.terraform.*`

The legacy model stored authentication, environment variables, and custom provider configuration directly on the Environment:

```bicep
// Legacy
properties: {
  recipeConfig: {
    terraform: {
      authentication: { ... }
      providers: { ... }
    }
    env: { ... }
  }
}
```

In the new model:

- `recipeConfig.terraform.authentication` → `terraformSettings.properties.terraformrc.credentials`
- `recipeConfig.terraform.providers` → Recipe `parameters` referencing `Radius.Security/secrets`
- `recipeConfig.env` → `terraformSettings.properties.env`

See the [migration guide]({{< ref "guides/operations/migration" >}}) for end-to-end before/after examples.

## Further reading

- [Compute extensibility concepts]({{< ref "concepts/compute-extensibility" >}})
- [Recipe Packs how-to]({{< ref "guides/recipes/recipe-packs" >}})
- [BicepSettings how-to]({{< ref "guides/recipes/howto-bicep-settings" >}})
- [Migration guide]({{< ref "guides/operations/migration" >}})
- [Terraform and Bicep Settings feature spec](https://github.com/radius-project/design-notes/blob/main/features/2025-08-14-terraform-bicep-settings.md)
