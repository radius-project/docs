---
type: docs
title: "How to manage Recipe Packs"
linkTitle: "Manage Recipe Packs"
description: "Learn how to create, assign, update, and manage Recipe Packs"
weight: 300
aliases:
  - /guides/recipe-packs/
---

A [Recipe Pack]({{< ref "/concepts/recipe-packs" >}}) is a Radius resource that groups recipes by Resource Type. Recipe Packs are created in the Radius control plane and assigned to Environments to control how Radius provisions infrastructure. This guide focuses on using community-maintained Recipe Packs and creating fully custom Recipe Packs.

## Using community Recipe Packs

The Radius community maintains a set of Recipe Packs and respective recipes in the [radius/project/resource-types-contrib repository](https://github.com/radius-project/resource-types-contrib/tree/main/recipe-packs/). When Radius is installed, the [`kubernetes` Recipe Pack](https://github.com/radius-project/resource-types-contrib/tree/main/recipe-packs/kubernetes) is created within Radius and named `default`. This Recipe Pack deploys all applications and its resources to Kubernetes.

The community also maintains Recipe Packs for deploying applications to AWS and Azure. For example, the `azure-aks` Recipe Pack includes Bicep recipes that deploy containers to Kubernetes and databases to managed Azure services such as Azure Database for PostgreSQL and Azure Cache for Redis. Deploy it directly from its URL:

```bash
rad deploy https://raw.githubusercontent.com/radius-project/resource-types-contrib/main/recipe-packs/azure-aks/azure-aks.bicep
```

This creates the `azure-aks` Recipe Pack in the Radius control plane.

List the Recipe Packs in a Resource Group:

```bash
rad recipe-pack list --group default
```

Show the details of the Recipe Pack:

```bash
rad recipe-pack show azure-aks
```

Then [assign it to an Environment]({{< ref "/management/environments#update-an-environment" >}}).

## Creating a new Recipe Pack

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

Deploy the file to create the Recipe Pack. `rad deploy` creates the Recipe Pack when it does not exist and updates it when it already exists:

```bash
rad deploy recipe-pack.bicep
```

List the Recipe Packs in a Resource Group:

```bash
rad recipe-pack list --group default
```

Show the details of the Recipe Pack:

```bash
rad recipe-pack show data-recipes
```

Then [assign it to an Environment]({{< ref "/management/environments#update-an-environment" >}}).

## Update a Recipe Pack

Edit `recipe-pack.bicep`, then deploy it again:

```bash
rad deploy recipe-pack.bicep
```

Keep the Recipe Pack name stable so existing Environment references remain valid. Before changing a recipe source, parameters, or outputs, review every Environment that references the pack. The change affects subsequent deployments of that Resource Type in those Environments.

Prefer publishing a new immutable recipe version and updating the `source` property to that version. Test the updated pack in a non-production Environment before using it in production.

## Delete a Recipe Pack

Delete the Recipe Pack from the Radius control plane:

```bash
rad recipe-pack delete data-recipes
```

The command prompts for confirmation, removes the Recipe Pack from every Environment that references it, and then deletes the Recipe Pack. If Radius cannot update one of those Environments, the command returns an error and does not delete the Recipe Pack.

Use `--yes` only in automation where the deletion has already been validated.

## Next steps

Now that Recipe Packs have been created, learn how to use existing modules as recipes.

{{< button text="Next step: How to use existing modules as recipes" page="/management/existing-recipes" >}}
