---
type: docs
title: "How to use existing modules as Recipes"
linkTitle: "Use existing Recipes"
description: "Use an already-published Terraform or Bicep module as a Radius Recipe without modifying it"
weight: 300
---

Radius can use an existing Terraform or Bicep module that has already been published to a registry or repository as a [recipe]({{< ref "/concepts/recipe-packs" >}}), without changing the module. Point a recipe's `source` at a community module such as a [Terraform Registry module](https://registry.terraform.io/) or an [Azure Verified Module](https://azure.github.io/Azure-Verified-Modules/), map the developer-facing inputs to the module's parameters, and map the module's outputs back to your Resource Type's properties. You consume the module exactly as its authors published it.

Use this approach when a published module already provisions the infrastructure you need and you want to adopt it as-is. If instead you want to write a new recipe of your own that declares its own `context` inputs and `result` output, see [How to create a custom recipe with Radius]({{< ref "/extensibility/custom-recipes" >}}).

## Existing modules versus custom recipes

A [custom recipe]({{< ref "/extensibility/custom-recipes" >}}) is one you write yourself: you author a Terraform module or Bicep template that declares a `context` input and returns a structured `result` output built for a specific Resource Type. An existing recipe reuses a module that someone else has already published, such as a community Terraform Registry module or an Azure Verified Module. You reference the published module unchanged and let Radius connect it to your Resource Type:

- `parameters` supply the module's inputs, including values resolved from the Radius `context` at deploy time.
- `outputs` map the module's output names to the properties defined by your Resource Type.

Both kinds of recipe live in a Recipe Pack, so you can mix custom recipes and existing modules across the Resource Types in a single pack.

## Reference an existing module

Add the module to a [Recipe Pack]({{< ref "/extensibility/recipe-packs" >}}) recipe definition. Set `kind` to `terraform` or `bicep` and set `source` to the module. The module must be fetched from a remote registry, Git, or OCI reference; local filesystem paths are not supported. Always pin an immutable version, because Radius does not upgrade modules automatically and a version that is later removed from its registry causes the recipe to fail at download.

{{< tabs Terraform Bicep >}}

{{% codetab %}}

A Terraform module can be referenced in one of two ways, depending on where it is published. When the module is published to a Terraform registry, either the public Terraform Registry or a private one, reference it by its registry path and append the version with a colon (`<source>:<version>`), since a registry path is not a URL:

```bicep
extension radius

resource dataRecipes 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'aws-data-recipes'
  properties: {
    recipes: {
      'Radius.Data/mySqlDatabases': {
        kind: 'terraform'
        source: 'terraform-aws-modules/rds/aws:6.1.0'
        parameters: {
          identifier: '{{context.resource.name}}'
          db_name: '{{context.resource.properties.database}}'
          engine: 'mysql'
          engine_version: '8.0'
          instance_class: 'db.t3.micro'
          manage_master_user_password: true
        }
        outputs: {
          host: 'db_instance_address'
          port: 'db_instance_port'
          database: 'db_instance_name'
          password: 'db_instance_master_user_secret_arn'
        }
      }
    }
  }
}
```

When the module lives in a Git repository instead of a registry, set `source` to a `git::` URL and pin the version with `?ref=<tag>`:

```text
git::https://github.com/my-org/modules.git//rds?ref=v6.1.0
```

{{% /codetab %}}

{{% codetab %}}

Bicep modules are referenced by their OCI registry path, with the version in the image tag. For example, reference an Azure Verified Module from the Microsoft Container Registry:

```bicep
extension radius

resource dataRecipes 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'azure-data-recipes'
  properties: {
    recipes: {
      'Radius.Data/postgreSqlDatabases': {
        kind: 'bicep'
        source: 'br:mcr.microsoft.com/bicep/avm/res/db-for-postgre-sql/flexible-server:0.4.0'
        parameters: {
          name: 'pg-{{context.resource.name}}'
          location: 'eastus2'
          skuName: 'Standard_B1ms'
        }
        outputs: {
          host: 'fqdn'
          port: 'port'
          database: 'name'
        }
      }
    }
  }
}
```

{{% /codetab %}}

{{< /tabs >}}

The `parameters` and `outputs` names come from the module you reference, so consult the module's own documentation for its input variables and outputs. Radius passes only the parameters you map; every other input uses the module's own default.

## Resolve developer inputs with context expressions

Any `parameters` value can include a `{{context.*}}` expression. When Radius runs the recipe, it replaces the expression with a real value, such as a property the developer set on the resource, the resource's name, or a detail about the Environment or cloud provider. The [recipe context reference]({{< ref "/reference/recipes/context" >}}) lists every value you can read from `context`. For example:

```bicep
parameters: {
  identifier: '{{context.resource.name}}'
  db_name: '{{context.resource.properties.database}}'
}
```

An expression can also use a single-level ternary (`condition ? a : b`) to pick between two values, which is handy for mapping a developer-facing size to a provider-specific SKU:

```bicep
parameters: {
  instance_class: '{{context.resource.properties.size == "s" ? "db.t3.micro" : "db.r6g.large"}}'
}
```

An expression that references a path which does not exist resolves to an empty string, so double-check the paths you use.

## Map module outputs to properties

The `outputs` field maps each module output name to a property on your Resource Type, giving consumers a stable property interface regardless of how the module names its outputs. Radius resolves properties in this order: an `outputs` mapping first, then a `result` output if the module returns one, and finally a passthrough of matching names.

```bicep
outputs: {
  host: 'db_instance_address'
  port: 'db_instance_port'
}
```

Each entry is written as `<resource property>: '<module output>'`. In this example, `db_instance_address` and `db_instance_port` are outputs produced by the Terraform or Bicep module, while `host` and `port` are read-only properties defined on the Resource Type. Radius reads the module outputs and populates the matching read-only properties, which the resource and its connections can then consume.

If an `outputs` entry references a module output that does not exist, Radius leaves that property empty and logs a warning rather than failing the deployment. A module that returns no outputs produces a resource with no recipe-populated properties.

If a module output is sensitive, map it to a property the Resource Type marks with `x-radius-sensitive: true`. Radius keeps the plaintext out of the stored resource and handles it as a secret; see [Sensitive properties]({{< ref "/reference/resources/#sensitive-properties" >}}) in the Resource Types reference.

## Override parameters per Environment

Set `recipeParameters` on an Environment to override or extend a recipe's `parameters` for a specific Resource Type. Environment values merge with the recipe's `parameters` and take precedence for overlapping keys:

```bicep
resource devEnvironment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'dev'
  properties: {
    recipePacks: [dataRecipes.id]
    recipeParameters: {
      'Radius.Data/mySqlDatabases': {
        instance_class: 'db.t3.small'
        allocated_storage: 50
      }
    }
  }
}
```

## Use modules from private registries

Existing modules use the same download path as any other recipe, so private registries and repositories work through the Environment's existing settings resources. Configure `Radius.Core/terraformConfigs` for private Terraform registries or Git, and `Radius.Core/bicepConfigs` for private OCI registries, then reference them from the Environment. See [How to design and manage Environments]({{< ref "/management/environments#configure-terraformsettings-and-bicepsettings" >}}) for the available authentication settings.

## Next steps

Now that you have referenced an existing module as a recipe, add it to a Recipe Pack and assign that pack to an Environment.

{{< button text="Next step: How to manage Recipe Packs" page="/extensibility/recipe-packs" >}}
