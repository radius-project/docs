---
type: docs
title: "How to manage Recipe Packs"
linkTitle: "Manage Recipe Packs"
description: "Learn how to create, assign, update, and manage Recipe Packs"
weight: 300
aliases:
  - /guides/recipe-packs/
---

A [Recipe Pack]({{< ref "/concepts/recipe-packs" >}}) is a Radius resource that groups recipes by Resource Type. Platform engineers create Recipe Packs in the Radius control plane and assign them to Environments to control how Radius provisions infrastructure.

This guide focuses on managing the Recipe Pack resource after its recipes have been authored and published. To create and publish a recipe, see [How to use custom recipes with Radius]({{< ref "/extensibility/recipes" >}}).

## Step 1: Create a Recipe Pack

Define the Recipe Pack in a file named `recipe-pack.bicep`. Each key in `recipes` is the Resource Type that the recipe provisions. Set `kind` to `bicep` or `terraform`, and set `source` to the published recipe location:

```bicep
extension radius

resource dataRecipes 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'data-recipes'
  properties: {
    recipes: {
      'Radius.Data/redisCaches': {
        kind: 'bicep'
        source: 'ghcr.io/my-org/recipes/redis:v1.1.0'
        parameters: {
          sku: 'development'
        }
      }
      'Radius.Data/postgreSqlDatabases': {
        kind: 'terraform'
        source: 'git::https://github.com/my-org/recipes.git//postgresql?ref=v1.2.0'
      }
    }
  }
}
```

Deploy the file to create the Recipe Pack:

```bash
rad deploy recipe-pack.bicep
```

`rad deploy` creates the Recipe Pack when it does not exist and updates it when it already exists.

Confirm that the Recipe Pack exists:

```bash
rad recipe-pack show data-recipes
```

To list Recipe Packs in a Resource Group, run:

```bash
rad recipe-pack list --group default
```

## Step 2: Assign the Recipe Pack to an Environment

Use [`rad environment update`]({{< ref rad_environment_update >}}) to replace an Environment's Recipe Pack list. The following command configures the `default` Environment to use `data-recipes`:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment update default \
  --recipe-packs data-recipes \
  --preview
```

An Environment stores an array of Recipe Pack references. You can assign more than one Recipe Pack by passing a comma-separated list:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Environment implementation is no longer in preview. -->
```bash
rad environment update default \
  --recipe-packs data-recipes,compute-recipes \
  --preview
```

Each Resource Type can have only one recipe across all Recipe Packs assigned to an Environment. For example, `data-recipes` can provide a recipe for `Radius.Data/redisCaches` while `compute-recipes` provides one for `Radius.Compute/containers`. The two packs cannot both provide a recipe for `Radius.Data/redisCaches`, because Radius would not know which recipe to use.

The `--recipe-packs` option replaces the Environment's complete Recipe Pack list; it does not append to the existing list. Include every Recipe Pack that the Environment should continue to use each time you run the command. To assign a Recipe Pack stored in a different Resource Group, see [Reference a Recipe Pack across Resource Groups]({{< ref "/management/environments#reference-a-recipe-pack-across-resource-groups" >}}).

## Step 3: Update a Recipe Pack

Edit `recipe-pack.bicep`, then deploy it again:

```bash
rad deploy recipe-pack.bicep
```

Keep the Recipe Pack name stable so existing Environment references remain valid. Before changing a recipe source, parameters, or outputs, review every Environment that references the pack. The change affects subsequent deployments of that Resource Type in those Environments.

Prefer publishing a new immutable recipe version and updating the `source` property to that version. Test the updated pack in a non-production Environment before using it in production.

## Step 4: Delete a Recipe Pack

Delete the Recipe Pack from the Radius control plane:

```bash
rad recipe-pack delete data-recipes
```

The command prompts for confirmation, removes the Recipe Pack from every Environment that references it, and then deletes the Recipe Pack. If Radius cannot update one of those Environments, the command returns an error and does not delete the Recipe Pack.

Use `--yes` only in automation where the deletion has already been validated.
