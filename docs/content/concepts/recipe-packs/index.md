---
type: docs
title: "Recipe Packs concepts"
linkTitle: "Recipe Packs"
description: "Group, share, and version sets of Recipe assignments using Recipe Packs"
weight: 30
---

A **Recipe Pack** is a named, reusable bundle of Recipe assignments (Resource Type → Recipe). Recipe Packs are part of the [compute extensibility]({{< ref "concepts/compute-extensibility" >}}) model and are the recommended way to manage Recipes at scale.

## Why Recipe Packs

Before Recipe Packs, every Environment carried its own complete `recipes` map. Two Environments that should expose the same set of databases, queues, and containers had to duplicate the entire map, and a change to a single Recipe location required updating every Environment that used it.

Recipe Packs solve this by:

- **Decoupling Recipe selection from Environments.** A Recipe Pack is an independently-deployed resource that can be referenced by many Environments.
- **Letting platforms be composed.** An Environment can reference multiple Recipe Packs — for example, a `kubernetes-compute` pack plus an `aws-data-services` pack — instead of redefining everything in one place.
- **Making upgrades atomic.** Updating the Recipe for a Resource Type in one Recipe Pack flows to every Environment that references that pack on its next deployment.

## Anatomy of a Recipe Pack

```bicep
resource awsDataServices 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'aws-data-services'
  properties: {
    recipes: {
      'Radius.Data/postgreSql': {
        default: {
          recipeKind: 'terraform'
          recipeLocation: 'git::https://github.com/myorg/recipes//aws-postgres?ref=v1.2.0'
          parameters: {
            instanceClass: 'db.t3.medium'
          }
        }
      }
      'Radius.Messaging/rabbitMQ': {
        default: {
          recipeKind: 'bicep'
          recipeLocation: 'ghcr.io/myorg/recipes/rabbitmq:1.0.0'
        }
      }
    }
  }
}
```

A Recipe Pack contains, per Resource Type, one or more **named** Recipe entries (`default` is conventional). Each entry specifies:

| Field            | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `recipeKind`     | `bicep` or `terraform`.                                                      |
| `recipeLocation` | The OCI image reference (Bicep) or Git/module source (Terraform).            |
| `parameters`     | Optional Recipe parameters that should be passed when this Recipe is run.    |

## Referencing Recipe Packs from Environments

```bicep
resource myEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'production-east'
  properties: {
    recipePacks: [
      kubernetesCompute.id
      awsDataServices.id
    ]
  }
}
```

If two Recipe Packs both define a Recipe for the same Resource Type and name, the **later entry in the `recipePacks` array wins**. Order packs with the most-specific overrides last.

## How Recipe Packs interact with BicepSettings and TerraformSettings

Recipe Packs only describe *which* Recipe to run for a Resource Type. *How* the Recipe is fetched and executed — private registry credentials, Terraform provider mirrors, backend state — is described by the [BicepSettings]({{< ref "guides/recipes/howto-bicep-settings" >}}) and [TerraformSettings]({{< ref "guides/recipes/howto-terraform-settings" >}}) resources that the Environment references.

This separation lets the same Recipe Pack be reused across Environments that pull from different registries or use different Terraform backends.

## Next steps

- Author a Recipe Pack with the [Recipe Packs how-to guide]({{< ref "guides/recipes/recipe-packs" >}})
- Configure private Bicep registries with [BicepSettings]({{< ref "guides/recipes/howto-bicep-settings" >}})
- Configure Terraform with [TerraformSettings]({{< ref "guides/recipes/howto-terraform-settings" >}})
