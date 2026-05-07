---
type: docs
title: "Migrating to compute extensibility"
linkTitle: "Migration guide"
description: "Step-by-step guide for migrating an existing Radius solution from the legacy architecture to the compute extensibility model"
weight: 700
---

This guide walks platform engineers and application authors through migrating an existing Radius solution from the legacy architecture (where compute was hard-coded to Kubernetes and Recipes/registry settings were embedded inside `Environment.properties.recipeConfig`) to the new [compute extensibility]({{< ref "concepts/compute-extensibility" >}}) model.

> Read [Compute extensibility concepts]({{< ref "concepts/compute-extensibility" >}}) and [Recipe Packs concepts]({{< ref "concepts/recipe-packs" >}}) before working through the migration.

## What is changing

| Concern                                       | Legacy                                                     | New (compute extensibility)                                           |
|-----------------------------------------------|------------------------------------------------------------|------------------------------------------------------------------------|
| Container, gateway, secret store Resource Types | Built into Radius (`Applications.Core/containers`, etc.) | Recipe-backed Resource Types (`Radius.Compute/containers`, etc.)       |
| Mapping Resource Type → Recipe                | `Environment.properties.recipes`                           | `Radius.Core/recipePacks` referenced by the Environment                |
| Private Bicep registry authentication         | `Environment.properties.recipeConfig.bicep.authentication` | `Radius.Core/bicepSettings`                                            |
| Terraform CLI / backend / credentials         | `Environment.properties.recipeConfig.terraform.*`          | `Radius.Core/terraformSettings`                                        |
| Terraform binary lifecycle                    | Auto-downloaded by Application RP                          | `rad terraform install` / `rad terraform uninstall`                    |
| Custom Terraform provider credentials         | `recipeConfig.terraform.providers` map                     | Recipe parameters that reference `Radius.Security/secrets` values      |
| API namespace                                 | `Applications.*`                                           | `Radius.*` (Core, Compute, Data, Messaging, Security, …)               |
| API version                                   | `2023-10-01-preview`                                       | `2025-08-01-preview`                                                   |

For the complete list, see [Breaking changes]({{< ref "breaking-changes" >}}).

## Recommended migration order

1. **Inventory.** List the Environments, Applications, Recipes, and Secrets currently in use. Note any private registries, custom Terraform providers, and non-default Terraform configuration (mirrors, backends, env vars).
2. **Install Terraform** into the Radius control plane with `rad terraform install` so Terraform Recipes continue to execute after the auto-download is removed.
3. **Author Recipe Packs** that mirror the `recipes` block of each existing Environment.
4. **Author BicepSettings / TerraformSettings** that mirror each existing Environment's `recipeConfig`.
5. **Re-author each Environment** to reference the new Recipe Packs and Settings resources, using the `Radius.Core/environments@2025-08-01-preview` API.
6. **Update Applications** to use the new `Radius.Compute/*` (and other `Radius.*`) Resource Types.
7. **Validate** by deploying to a non-production Environment first, then rolling forward.

## Before / after: a Bicep Environment with private registry and Terraform settings

### Before (legacy)

```bicep
resource registrySecrets 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'registry-secrets'
  properties: {
    resource: 'registry-secrets/ecr'
    type: 'awsIRSA'
    data: {
      roleARN: { value: 'arn:aws:iam::123456789012:role/radius-ecr-pull' }
    }
  }
}

resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'my-env'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'my-namespace'
    }
    recipeConfig: {
      bicep: {
        authentication: {
          '123456789012.dkr.ecr.us-east-1.amazonaws.com': {
            secret: registrySecrets.id
          }
        }
      }
      terraform: {
        authentication: {
          git: {
            pat: {
              'github.com': { secret: gitSecret.id }
            }
          }
        }
      }
      env: {
        TF_LOG: 'INFO'
      }
    }
    recipes: {
      'Applications.Datastores/redisCaches': {
        default: {
          templateKind: 'terraform'
          templatePath: 'git::https://github.com/myorg/recipes//redis?ref=v1.0.0'
        }
      }
      'Applications.Messaging/rabbitMQQueues': {
        default: {
          templateKind: 'bicep'
          templatePath: '123456789012.dkr.ecr.us-east-1.amazonaws.com/recipes/rabbitmq:1.0.0'
        }
      }
    }
  }
}
```

### After (compute extensibility)

```bicep
// 1. Secrets — same idea, new namespace and API version.
resource gitSecret 'Radius.Security/secrets@2025-08-01-preview' = {
  name: 'git-pat'
  properties: {
    data: {
      token: { value: '<github-pat>' }
    }
  }
}

// 2. BicepSettings replaces recipeConfig.bicep.authentication.
resource myBicepSettings 'Radius.Core/bicepSettings@2025-08-01-preview' = {
  name: 'my-bicep-settings'
  properties: {
    registryAuthentication: {
      authenticationMethod: 'AwsIrsa'
      awsIamRoleArn: 'arn:aws:iam::123456789012:role/radius-ecr-pull'
    }
  }
}

// 3. TerraformSettings replaces recipeConfig.terraform.* and recipeConfig.env.
resource myTerraformSettings 'Radius.Core/terraformSettings@2025-08-01-preview' = {
  name: 'my-terraform-settings'
  properties: {
    terraformrc: {
      credentials: [
        {
          host: 'github.com'
          secret: gitSecret.id
        }
      ]
    }
    env: {
      TF_LOG: 'INFO'
    }
  }
}

// 4. Recipe Pack replaces the inline `recipes` map and uses the Radius.* types.
resource myRecipePack 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'my-recipes'
  properties: {
    recipes: {
      'Radius.Data/redis': {
        default: {
          recipeKind: 'terraform'
          recipeLocation: 'git::https://github.com/myorg/recipes//redis?ref=v1.0.0'
        }
      }
      'Radius.Messaging/rabbitMQ': {
        default: {
          recipeKind: 'bicep'
          recipeLocation: '123456789012.dkr.ecr.us-east-1.amazonaws.com/recipes/rabbitmq:1.0.0'
        }
      }
    }
  }
}

// 5. Environment becomes a thin reference to the resources above.
resource env 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'my-env'
  properties: {
    recipePacks: [myRecipePack.id]
    bicepSettings: myBicepSettings.id
    terraformSettings: myTerraformSettings.id
  }
}
```

## Before / after: an Application

### Before (legacy)

```bicep
resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'my-app'
  properties: { environment: env.id }
}

resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: { image: 'ghcr.io/myorg/frontend:1.0.0' }
    connections: {
      cache: { source: cache.id }
    }
  }
}

resource cache 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'cache'
  properties: {
    application: app.id
    environment: env.id
  }
}
```

### After (compute extensibility)

```bicep
resource app 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'my-app'
  properties: { environment: env.id }
}

resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: { image: 'ghcr.io/myorg/frontend:1.0.0' }
    connections: {
      cache: { source: cache.id }
    }
  }
}

resource cache 'Radius.Data/redis@2025-08-01-preview' = {
  name: 'cache'
  properties: {
    application: app.id
    environment: env.id
  }
}
```

The application graph and developer mental model are unchanged. What changed is that `Radius.Compute/containers` and `Radius.Data/redis` are now Recipe-backed Resource Types resolved via the Environment's Recipe Packs, instead of being built into Radius.

## Migrating custom Terraform providers

Replace `recipeConfig.terraform.providers` maps with **Recipe parameters** that reference `Radius.Security/secrets`. See the [TerraformSettings how-to]({{< ref "guides/recipes/howto-terraform-settings" >}}#step-4-inject-secrets-into-custom-terraform-providers) for a worked Datadog example.

## Validating the migration

After re-deploying the Environment and Application:

```bash
rad app list --environment my-env
rad resource list Radius.Compute/containers --environment my-env
rad recipe list --environment my-env
```

If a deployment fails, the Application RP logs include the Recipe lookup decisions and the resolved BicepSettings / TerraformSettings — these are usually the fastest way to see whether the new Environment is wired up correctly.

## What to do with the legacy resources

While the new `Radius.*` resources are stabilizing, the legacy `Applications.*` resources remain available so you can migrate incrementally. Once every Application in an Environment has been re-authored against `Radius.*` types and the Environment references its new Recipe Packs / Settings resources, the legacy `Applications.Core/environments` resource and any associated `recipeConfig` can be deleted.

For the full enumeration of breaking behaviour, see [Breaking changes]({{< ref "breaking-changes" >}}).

## Further reading

- [Compute extensibility concepts]({{< ref "concepts/compute-extensibility" >}})
- [Recipe Packs concepts]({{< ref "concepts/recipe-packs" >}})
- [Recipe Packs how-to]({{< ref "guides/recipes/recipe-packs" >}})
- [BicepSettings how-to]({{< ref "guides/recipes/howto-bicep-settings" >}})
- [TerraformSettings how-to]({{< ref "guides/recipes/howto-terraform-settings" >}})
- [Extensibility design notes](https://github.com/radius-project/radius/tree/main/eng/design-notes/extensibility)
- [`resource-types-contrib`](https://github.com/radius-project/resource-types-contrib)
