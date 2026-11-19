---
type: docs
title: "How to use existing modules as recipes"
linkTitle: "Use existing recipes"
description: "Use an already-published Terraform or Bicep module as a Radius recipe without modifying it"
weight: 400
aliases:
  - /extensibility/existing-recipes/
---

A [Recipe Pack]({{< ref "/management/recipe-packs" >}}) maps each Resource Type to the recipe that provisions it, and each recipe points at a Terraform module or Bicep template. This page shows how to use an existing module that is already published to a registry or repository as that recipe, without changing the module. Point a recipe's `source` at a community module such as a [Terraform Registry module](https://registry.terraform.io/) or an [Azure Verified Module](https://azure.github.io/Azure-Verified-Modules/), map the developer-facing inputs to the module's parameters, and map the module's outputs back to your Resource Type's properties. You consume the module exactly as its authors published it.

Use this approach when a published module already provisions the infrastructure you need and you want to adopt it as-is. If instead you want to write a new recipe of your own that declares its own `context` inputs and `result` output, see [How to create a custom recipe with Radius]({{< ref "/extensibility/custom-recipes" >}}). You can mix custom recipes and existing modules across the Resource Types in a single Recipe Pack.

## Reference an existing module

Add the module to a [Recipe Pack]({{< ref "/management/recipe-packs" >}}) recipe definition. Set `kind` to `terraform` or `bicep` and set `source` to the module. The module must be fetched from a remote registry, Git, or OCI reference; local filesystem paths are not supported. Always pin an immutable version, because Radius does not upgrade modules automatically and a version that is later removed from its registry causes the recipe to fail at download.

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

## Reference a module from a private registry or repository

When the module you reference is published privately, configure authentication on the Environment through a settings resource, then reference that resource from the Environment. Radius applies the credentials whenever a recipe pulls the module.

- **Bicep modules in a private OCI registry:** Configure a [`Radius.Core/bicepSettings`]({{< ref "/reference/resources/radius.core/2025-08-01-preview/bicepsettings" >}}) resource that maps the registry hostname to its authentication, then set the Environment's `bicepSettings` property to that resource's ID.
- **Terraform modules in a private registry:** Configure a [`Radius.Core/terraformSettings`]({{< ref "/reference/resources/radius.core/2025-08-01-preview/terraformsettings" >}}) resource with the registry token, stored in a `Radius.Security/secrets` resource, then set the Environment's `terraformSettings` property to that resource's ID. TerraformSettings authenticates Terraform CLI registries; Terraform modules referenced from a Git repository authenticate through a separate mechanism.

## Next steps

Now that you can reference existing modules as recipes, learn how to run application containers on other platforms.

{{< button text="Next step: How to use other container platforms" page="/management/container-platforms" >}}
