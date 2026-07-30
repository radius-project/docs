---
type: docs
title: "How to create custom Resource Types"
linkTitle: "Create custom Resource Types"
description: "Learn how to create a custom Resource Type in Radius"
weight: 100
aliases:
  - /guides/resource-types/
---

[Resource Types]({{< ref "concepts/resource-types" >}}) define the resources developers use to model an application. A Resource Type specifies the properties developers provide, the values Radius returns, and the API versions available for that resource.

Use a custom Resource Type when the [out-of-the-box Resource Types]({{< ref "/reference/resources" >}}) do not model what your developers need. This guide explains how to design the type, define its schema and provisioning behavior, register it with Radius, and make it available to Bicep authors.

## Use community Resource Types as examples

The [`radius-project/resource-types-contrib`](https://github.com/radius-project/resource-types-contrib) repository is the community-maintained source for Resource Types and recipes that ship with Radius. Each Resource Type directory contains its schema and implementations for supported deployment targets, making the repository a useful source of complete examples.

Before defining a Resource Type from scratch, look for one with similar properties, capabilities, or infrastructure requirements. You can adapt an existing definition for your organization or follow the [contribution guide](https://github.com/radius-project/resource-types-contrib/blob/main/docs/contributing/contributing-resource-types-recipes.md) to propose a Resource Type and recipes for the community library.

## Step 1: Choose the namespace, type name, and API version

A Resource Type definition starts with a namespace, one or more type names, and at least one API version:

```yaml
namespace: MyCompany.Resources
types:
  widgets:
    description: Resources that represent widgets managed by MyCompany.
    apiVersions:
      '2025-08-01-preview':
        schema:
          type: object
```

Use a namespace that identifies your organization. Namespaces use the `PrimaryName.SecondaryName` format; the `Radius.` prefix is reserved for built-in and community-maintained types. Type names are typically plural and camelCase.

Use a date-based API version such as `2025-08-01-preview`. Add a new API version when making a breaking schema change so existing applications can continue using the earlier contract.

## Step 2: Define the resource properties

Under each API version, define an OpenAPI schema for the resource. Use `required` for properties developers must supply and `readOnly` for values populated after provisioning:

```yaml
schema:
  type: object
  properties:
    environment:
      type: string
      description: The Radius Environment resource ID.
    application:
      type: string
      description: The Radius Application resource ID.
    size:
      type: string
      enum: [small, medium, large]
      description: The requested resource size.
    endpoint:
      type: string
      readOnly: true
      description: The endpoint returned after the resource is provisioned.
  required: [environment, size]
```

Radius supports string, integer, number, boolean, array, and object properties. Object properties can contain named `properties` or define a typed map with `additionalProperties`. See [Defining a Resource Type]({{< ref "/reference/resources/#defining-a-resource-type" >}}) for the complete schema conventions.

## Step 3: Choose the provisioning behavior

Most Resource Types use a [recipe]({{< ref "/extensibility/custom-recipes" >}}) to provision backing infrastructure. For a recipe-backed Resource Type, omit `capabilities`; the Recipe Pack assigned to the Environment determines which recipe Radius runs.

Use `ManualResourceProvisioning` only when Radius should store the supplied properties without running a recipe:

```yaml
types:
  widgets:
    capabilities:
      - ManualResourceProvisioning
```

Manual provisioning is suitable for resources that model infrastructure managed outside Radius. It does not create, update, or delete backing infrastructure.

## Step 4: Handle sensitive properties

For a recipe-backed Resource Type, mark sensitive string or object properties with `x-radius-sensitive`:

```yaml
properties:
  apiKey:
    type: string
    x-radius-sensitive: true
    description: An API key passed securely to the recipe.
```

Radius encrypts these values at rest, redacts them from reads, and decrypts them only when needed by the recipe. For a manually provisioned type, store secrets in a separate [`Radius.Security/secrets`]({{< ref "/reference/resources/radius.security" >}}) resource and expose only its resource ID on the custom type.

## Step 5: Create and inspect the Resource Type

Save the complete definition as a YAML or JSON file. Create or update all Resource Types in the file with [`rad resource-type create`]({{< ref rad_resource-type_create >}}):

```bash
rad resource-type create --from-file resource-types.yaml
```

To create or update only one type from a file containing several types, provide its simple name:

```bash
rad resource-type create widgets --from-file resource-types.yaml
```

Inspect the registered type with [`rad resource-type show`]({{< ref rad_resource-type_show >}}), or use `rad resource-type list` to list all registered types:

```bash
rad resource-type show MyCompany.Resources/widgets
rad resource-type list
```

## Step 6: Publish a Bicep extension

Registering the Resource Type makes it available to the Radius control plane. To give developers type checking and authoring support in Bicep, compile the definition into a Bicep extension with [`rad bicep publish-extension`]({{< ref rad_bicep_publish-extension >}}).

See [Distribute Bicep extensions to developers]({{< ref "/installation/dev-workstation#distribute-bicep-extensions-to-developers" >}}) to publish the extension to Azure Container Registry or a local file and configure it in each developer's `bicepconfig.json`.

## Next steps

After creating a custom Resource Type, create a recipe which deploys the new Resource Type to a cloud provider.

{{< button text="Next step: How to create a custom recipe" page="/extensibility/custom-recipes" >}}
