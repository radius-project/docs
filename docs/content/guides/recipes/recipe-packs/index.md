---
type: docs
title: "How-To: Author and consume Recipe Packs"
linkTitle: "Recipe Packs"
description: "Create a Recipe Pack and reference it from one or more Radius Environments"
weight: 200
categories: "How-To"
tags: ["recipes", "recipe packs", "extensibility"]
---

This guide walks through creating a Radius **Recipe Pack** and using it from an Environment. Recipe Packs are part of the [compute extensibility]({{< ref "concepts/compute-extensibility" >}}) model. They let platform engineers manage `Resource Type → Recipe` assignments as a reusable resource shared across Environments. See the [Recipe Packs concept page]({{< ref "concepts/recipe-packs" >}}) for the conceptual overview.

> **Preview API:** Recipe Packs use the `2025-08-01-preview` API version. The schema may change as the feature is finalized.

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius initialized with `rad init`]({{< ref howto-environment >}})
- One or more published Recipe templates (Bicep in an OCI registry, Terraform in a Git repository)

## Step 1: Author the Recipe Pack

Create `recipePack.bicep`:

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
      'Radius.Compute/secretStores': {
        default: {
          recipeKind: 'bicep'
          recipeLocation: 'ghcr.io/myorg/recipes/secretstore:1.0.0'
        }
      }
    }
  }
}

output recipePackId string = computeRecipePack.id
```

Each entry under `recipes` is keyed by the fully-qualified Resource Type name and contains one or more **named** Recipe entries. `default` is the conventional name for the Recipe selected when the developer does not request a specific Recipe.

## Step 2: Deploy the Recipe Pack

Recipe Packs are deployed like any other Radius resource:

```bash
rad deploy ./recipePack.bicep --group platform
```

You can list deployed Recipe Packs with:

```bash
rad resource list Radius.Core/recipePacks --group platform
```

## Step 3: Reference the Recipe Pack from an Environment

Create or update your Environment to point at the Recipe Pack:

```bicep
resource computeRecipePack 'Radius.Core/recipePacks@2025-08-01-preview' existing = {
  name: 'kubernetes-compute'
  scope: resourceGroup('platform')
}

resource myEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'production-east'
  properties: {
    recipePacks: [computeRecipePack.id]
  }
}
```

Deploy:

```bash
rad deploy ./environment.bicep --group production
```

Any Application deployed to `production-east` will now resolve `Radius.Compute/containers`, `Radius.Compute/gateways`, and `Radius.Compute/secretStores` against the Recipe Pack you just registered.

## Step 4 (optional): Compose multiple Recipe Packs

An Environment can reference more than one Recipe Pack. The packs are evaluated in array order, and **later entries override earlier ones** when two packs define a Recipe for the same Resource Type and name:

```bicep
properties: {
  recipePacks: [
    baseCompute.id          // generic defaults
    awsDataServices.id      // adds Radius.Data/* recipes
    productionOverrides.id  // overrides the container recipe with a hardened variant
  ]
}
```

## Updating a Recipe Pack

Updating the Recipe Pack resource (for example, bumping `recipeLocation` to a new tag) and redeploying it is enough — every Environment that references the pack will use the new Recipes on the next deployment. There is no need to redeploy the Environment.

## Further reading

- [Recipe Packs concepts]({{< ref "concepts/recipe-packs" >}})
- [Compute extensibility concepts]({{< ref "concepts/compute-extensibility" >}})
- [BicepSettings how-to]({{< ref "guides/recipes/howto-bicep-settings" >}})
- [TerraformSettings how-to]({{< ref "guides/recipes/howto-terraform-settings" >}})
- [Migration guide]({{< ref "guides/operations/migration" >}})
