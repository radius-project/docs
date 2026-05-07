---
type: docs
title: "Compute extensibility concepts"
linkTitle: "Compute extensibility"
description: "Understand the compute extensibility model in Radius and how it changes the way platforms, environments, recipes, and applications are composed"
weight: 25
---

Compute extensibility is the evolution of the Radius architecture that removes the previous hard-coded coupling between Radius and a specific compute platform (Kubernetes). With compute extensibility, the compute platform itself — Kubernetes today, but other platforms in the future — is modeled as a Radius Resource Type that platform engineers select, configure, and back with Recipes, exactly like every other resource in Radius.

This page describes the new model conceptually. For step-by-step migration from the legacy architecture, see the [migration guide]({{< ref "guides/operations/migration" >}}).

## What changed and why

Before compute extensibility, the *compute* in `Environment.properties.compute` was a special, built-in field with hard-coded support for `kubernetes`. Containers were modeled by the built-in `Applications.Core/containers` Resource Type and were always rendered into Kubernetes objects by the Application RP. Adding a new compute platform required changes to Radius itself.

With compute extensibility:

- **Compute platforms are Resource Types.** Compute resources (for example, `Radius.Compute/containers`, `Radius.Compute/gateways`, `Radius.Compute/secretStores`) are user-resolvable Resource Types with Recipes — they are not hard-coded into Radius. A platform engineer can swap or extend the compute implementation by registering a different Recipe.
- **The Environment is decomposed.** Configuration that previously lived inside a single, monolithic `Environment.properties.recipes` and `Environment.properties.recipeConfig` is now factored into dedicated, independently-managed resources: **Recipe Packs**, **BicepSettings**, and **TerraformSettings**. Environments reference these resources by ID.
- **A new resource namespace.** New, extensible resource types live under the `Radius.*` namespace (for example `Radius.Core/environments`, `Radius.Core/recipePacks`, `Radius.Compute/containers`). The legacy `Applications.*` namespace remains while users migrate.

The result is a smaller, more pluggable core and a much cleaner separation between *what* a Resource Type is and *how* it is implemented.

## The new building blocks

### Resource Types in `Radius.Compute`

Compute resources used by application developers — containers, gateways, secret stores, volumes — now live under `Radius.Compute/*`. Each of them is a Resource Type with the same authoring model as any other Recipe-backed Resource Type. See the [Resource Types concept page]({{< ref "concepts/resource-types" >}}) for the general model and the [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) repository for reference implementations.

### Recipe Packs

A **Recipe Pack** is a reusable, named collection of Recipe assignments that can be referenced by one or more Environments. Recipe Packs let platform engineers manage the mapping of *Resource Type → Recipe* in a single place and reuse it across many Environments instead of repeating the entire `recipes` map per Environment.

```bicep
resource computeRecipePack 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'kubernetes-compute'
  properties: {
    recipes: {
      'Radius.Compute/containers': {
        default: {
          recipeKind: 'bicep'
          recipeLocation: 'ghcr.io/myorg/recipes/container:1.0.0'
        }
      }
      'Radius.Compute/gateways': {
        default: {
          recipeKind: 'terraform'
          recipeLocation: 'git::https://github.com/myorg/recipes//gateway?ref=v1.0.0'
        }
      }
    }
  }
}
```

See the [Recipe Packs concept page]({{< ref "concepts/recipe-packs" >}}) and the [Recipe Packs how-to guide]({{< ref "guides/recipes/recipe-packs" >}}) for details.

### BicepSettings and TerraformSettings

Settings that previously lived inside `Environment.properties.recipeConfig` are now first-class resources:

- **`Radius.Core/bicepSettings`** holds OCI registry authentication for private Bicep registries. It replaces `Environment.properties.recipeConfig.bicep.authentication`. See the [BicepSettings how-to guide]({{< ref "guides/recipes/howto-bicep-settings" >}}).
- **`Radius.Core/terraformSettings`** holds the Terraform CLI configuration (`terraformrc`), backend configuration, and process environment variables. It replaces `Environment.properties.recipeConfig.terraform.*`. See the [TerraformSettings how-to guide]({{< ref "guides/recipes/howto-terraform-settings" >}}).

Environments reference these resources by ID:

```bicep
resource myEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'myEnvironment'
  properties: {
    recipePacks: [computeRecipePack.id]
    bicepSettings: myBicepSettings.id
    terraformSettings: myTerraformSettings.id
  }
}
```

### Terraform is platform-engineer-managed

Radius no longer downloads the Terraform binary on demand. Platform engineers explicitly install Terraform into the Radius control plane with `rad terraform install` and upgrade or remove it with the same command family. This puts Terraform versioning, mirror selection, and lifecycle in the platform engineer's control. See the [TerraformSettings how-to guide]({{< ref "guides/recipes/howto-terraform-settings" >}}).

## How the pieces fit together

```text
                    ┌──────────────────────┐
                    │  Radius.Core/        │
                    │  environments        │
                    └──────────┬───────────┘
                               │ references
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
        ▼                      ▼                      ▼
┌───────────────┐   ┌────────────────────┐   ┌─────────────────────┐
│ recipePacks[] │   │  bicepSettings     │   │  terraformSettings  │
│ (one or many) │   │  (private OCI auth)│   │  (CLI / backend /   │
└──────┬────────┘   └────────────────────┘   │   provider creds)   │
       │ recipes for                         └─────────────────────┘
       ▼ Resource Types
┌─────────────────────────────────────────────────────────────────┐
│  Radius.Compute/containers, gateways, secretStores, volumes …  │
│  (and any other Resource Types defined by platform engineers)  │
└─────────────────────────────────────────────────────────────────┘
```

When a developer deploys an Application, Radius:

1. Looks up the Resource Type referenced by each resource in the Application.
2. Finds the matching Recipe by walking the Environment's referenced Recipe Packs.
3. Applies any BicepSettings / TerraformSettings the Environment references when invoking the Bicep or Terraform CLI.
4. Returns the Recipe `result` outputs to Radius, which populates the resource's read-only properties.

## Status and stability

The compute extensibility resources use the `2025-08-01-preview` API version. Schemas and behavior may continue to evolve until the APIs are promoted to stable. Track the in-flight design notes under [`radius/eng/design-notes/extensibility`](https://github.com/radius-project/radius/tree/main/eng/design-notes/extensibility) and the related [Terraform and Bicep settings feature spec](https://github.com/radius-project/design-notes/blob/main/features/2025-08-14-terraform-bicep-settings.md).

## Next steps

- Read the [Recipe Packs concept page]({{< ref "concepts/recipe-packs" >}})
- Follow the [migration guide]({{< ref "guides/operations/migration" >}}) to move an existing solution to the new model
- Review [breaking changes]({{< ref "guides/operations/migration/breaking-changes" >}})
