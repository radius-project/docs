---
type: docs
title: "Resource Types"
linkTitle: "Resource Types"
description: "Schema reference for built-in Resource Types"
weight: 200
---

## Introduction

Resource Types define the schema for the resources developers use to model their applications—the properties you can configure, the values Radius returns, and the API versions each type supports. For a deeper explanation of what Resource Types are and how they abstract the underlying infrastructure, see the [Resource Types concepts]({{< ref "concepts/resource-types" >}}) page.

All of the schema information on these pages is also available directly from your environment using [`rad resource-type list`]({{< ref rad_resource-type_list >}}) and [`rad resource-type show`]({{< ref rad_resource-type_show >}}), as well as through the [Radius Dashboard]({{< ref "/installation/dashboard" >}}).

## Out-of-the-box Resource Types

Radius provides two categories of out-of-the-box Resource Types:

- **`Radius.Core`** types are built into Radius itself and provide its core API. These types are always present and are managed by Radius.
- **All other out-of-the-box types** are maintained in the [resource-types-contrib](https://github.com/radius-project/resource-types-contrib) repository and installed as defaults. This community-maintained repository is the home for these Resource Types and their Recipes.

The following Resource Types are available out of the box. Every namespace except `Radius.Core` is defined in the [`defaults.yaml`](https://github.com/radius-project/radius/blob/main/deploy/manifest/defaults.yaml) manifest and sourced from resource-types-contrib:

| Namespace | Resource Types |
|-----------|----------------|
| `Radius.Core` | `applications`, `environments`, `recipePacks`, `bicepSettings`, `terraformSettings` |
| `Radius.Compute` | `containers`, `containerImages`, `persistentVolumes`, `routes` |
| `Radius.Data` | `postgreSqlDatabases`, `mySqlDatabases`, `sqlServerDatabases`, `mongoDatabases`, `redisCaches` |
| `Radius.Messaging` | `kafka`, `rabbitMQ` |
| `Radius.AI` | `search`, `models` |
| `Radius.Security` | `secrets` |
| `Radius.Storage` | `objectStorage` |

Because these types are pinned in a versioned manifest, the exact list can change between releases. Refer to [`defaults.yaml`](https://github.com/radius-project/radius/blob/main/deploy/manifest/defaults.yaml) for the definitive set that ships with your version of Radius, or list the types registered in your installation with:

```bash
rad resource-type list
```

## Defining a Resource Type

Custom Resource Types are defined in a YAML file. See [How to create a custom Resource Type]({{< ref "/extensibility/resource-types" >}}) for a walkthrough, or the [resource-types-contrib contribution guide](https://github.com/radius-project/resource-types-contrib/blob/main/docs/contributing/contributing-resource-types-recipes.md) to contribute a Resource Type and Recipe to the community library. A few conventions apply to every definition:

- **Namespace** groups related Resource Types and follows the `PrimaryName.SecondaryName` format. Use a namespace that identifies your organization, such as `MyCompany.Radius`. The `Radius.` prefix is reserved for built-in and resource-types-contrib types.
- **Type names** are typically plural and camelCase, for example `externalServices`.
- **`required`** lists the properties a developer must provide. Everything else is optional.
- **`readOnly`** properties are set by the Recipe as outputs after the resource is deployed.
- **`capabilities`** opts a Resource Type into optional Radius behaviors. `ManualResourceProvisioning` is currently the only supported capability. It tells Radius that the resource is not provisioned by a Recipe: Radius stores the properties the developer provides without running a Recipe to create backing infrastructure. Omit `capabilities` for Resource Types whose infrastructure is provisioned by a Recipe.

### Supported property types

Every property must declare a `type`. Radius supports these types:

- **`string`**: text values.
- **`integer`**: whole numbers.
- **`number`**: floating-point numbers.
- **`boolean`**: `true` or `false`.
- **`array`**: a list of items of a single type.
- **`object`**: either a nested set of `properties`, or a map of key/value pairs declared with `additionalProperties`. A single object cannot define both `properties` and `additionalProperties`, and `additionalProperties: true` is not allowed, so provide a schema for the map's values instead.

To restrict a property to a fixed set of values, add an `enum`, for example `enum: ['basic', 'apiKey', 'jwt']`.

### Sensitive properties

Some resources need to store secrets such as API keys, passwords, or connection strings. Mark a property with the `x-radius-sensitive` annotation to have Radius protect it:

```yaml
properties:
  apiKey:
    type: string
    x-radius-sensitive: true
```

When a property is marked `x-radius-sensitive: true`, Radius:

- **Never persists the plaintext on the resource.** A value the developer supplies is encrypted in transit and redacted from the stored resource after provisioning. A value a Recipe returns as a secret is materialized into a separate Radius-managed [`Radius.Security/secrets`]({{< ref "/reference/resources/radius.security" >}}) resource that the resource references by name; if the Resource Type declares no `secrets` block, the secret output is dropped rather than stored.
- **Redacts the value from reads**, including `rad resource show`, the Radius Dashboard, and the resource API.
- **Decrypts the value only in memory**, such as when passing it to the resource's Recipe.

The annotation has two constraints:

- It is only supported on `string` and `object` properties, a limitation of the Bicep type system.
- The property must declare an explicit `type`.

Because Radius only decrypts sensitive values when running a Recipe, `x-radius-sensitive` is intended for Resource Types provisioned by a Recipe. For a Resource Type that uses `ManualResourceProvisioning` and has no Recipe, store secrets in a separate [`Radius.Security/secrets`]({{< ref "/reference/resources/radius.security" >}}) resource and reference it by ID instead.

## How this section is organized

Resource Types are organized first by namespace (such as `Radius.Core`, `Radius.Compute`, and `Radius.Data`) and then by API version (for example, `2025-08-01-preview`). Open a Resource Type to view its schema reference, which documents the resource's properties, including which fields are required and read-only.

