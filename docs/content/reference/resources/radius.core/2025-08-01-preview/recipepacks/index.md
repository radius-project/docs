---
type: docs
title: "Radius.Core/recipePacks@2025-08-01-preview"
linkTitle: "RecipePacks"
---

{{< schemaExample >}}

## Description

The `Radius.Core/recipePacks` Resource Type represents a Recipe Pack: a named collection of Recipes that platform engineers assign to an Environment. A Recipe maps a resource type (such as `Radius.Data/redisCaches`) to an infrastructure-as-code module, a Terraform module or Bicep template, that provisions the infrastructure backing that resource when a developer deploys it.

A Recipe Pack is defined as its own resource and referenced from an Environment's `recipePacks` property, so one Recipe Pack can be shared across many Environments.

### Defining a Recipe Pack

Each entry in the `recipes` map is keyed by resource type. Set the recipe `kind` (`bicep` or `terraform`) and its `source` (an OCI registry reference for Bicep recipes, or a module source for Terraform recipes).

```bicep
extension radius

resource dataRecipes 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'data-recipes'
  properties: {
    recipes: {
      'Radius.Data/redisCaches': {
        kind: 'bicep'
        source: 'ghcr.io/my-org/recipes/redis:latest'
      }
      'Radius.Data/postgreSqlDatabases': {
        kind: 'terraform'
        source: 'git::https://github.com/my-org/recipes//postgresql'
      }
    }
  }
}
```

### Recipe parameters

Each Recipe can declare default `parameters` that are passed to its module. Platform engineers set baseline values here, and developers get them automatically. An Environment can override these values per resource type through its `recipeParameters` property.

```bicep
resource dataRecipes 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'data-recipes'
  properties: {
    recipes: {
      'Radius.Data/redisCaches': {
        kind: 'bicep'
        source: 'ghcr.io/my-org/recipes/redis:latest'
        parameters: {
          sku: 'Standard'
          capacity: 1
        }
      }
    }
  }
}
```

### Deploying a Recipe Pack

Deploy the Bicep file with `rad deploy` to create the Recipe Pack resource. Once deployed, list and inspect Recipe Packs with the `rad recipe-pack list` and `rad recipe-pack show` commands.

### Referencing a Recipe Pack from an Environment

An Environment references a Recipe Pack through its `recipePacks` property. When the Recipe Pack and the Environment are deployed to the same resource group, declare it as an `existing` resource and reference its `.id`:

```bicep
extension radius

resource dataRecipes 'Radius.Core/recipePacks@2025-08-01-preview' existing = {
  name: 'data-recipes'
}

resource myEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'my-environment'
  properties: {
    recipePacks: [
      dataRecipes.id
    ]
  }
}
```

To reference a Recipe Pack in a different resource group, use its full resource ID instead:

```bicep
recipePacks: [
  '/planes/radius/local/resourceGroups/shared/providers/Radius.Core/recipePacks/data-recipes'
]
```

Radius is installed with a `default` Recipe Pack in the `default` resource group. When you create an Environment with the Radius CLI and do not set `recipePacks`, the Environment uses this `default` Recipe Pack.

Prebuilt Recipe Packs and the Recipes they reference are published in the [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) repository.

For more information, see the Radius documentation at https://docs.radapp.io.

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `provisioningState` | string | (Read Only) The status of the Recipe Pack resource within the Radius control plane.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `recipes` | [object](#recipes) | (Required) The Recipes in this pack, keyed by the resource type each Recipe provisions. Each key is a resource type such as `Radius.Data/redisCaches`. |
| `referencedBy` | string array | (Read Only) Resource IDs of the Environments that reference this Recipe Pack. |

## Object Properties

### `recipes` {#recipes}

| Property | Type | Description |
|----------|------|-------------|
| `kind` | string | (Required) The kind of Recipe, which determines how Radius runs it.<br />Allowed values: `bicep`, `terraform`. |
| `outputs` | object | (Optional) Maps the module outputs onto the resource type properties for recipes that point directly at a Bicep or Terraform module. Each value is the module output name for a non-secret property. Under the reserved `secrets` key a nested object maps secret property names to module output names and always routes those outputs to the resource secret outputs. |
| `parameters` | object | (Optional) Default parameter values passed to the Recipe when it runs. An Environment can override these per resource type through its `recipeParameters` property. |
| `plainHttp` | boolean | (Optional) Connect to the source using HTTP instead of HTTPS. Use this only when the source does not support HTTPS such as a locally hosted registry for Bicep recipes. Defaults to `false` if not specified. |
| `source` | string | (Required) Location of the Recipe. For Bicep Recipes this is an OCI registry reference. For Terraform Recipes this is the module source such as a Git URL or a Terraform registry module. |
