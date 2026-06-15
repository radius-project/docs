---
type: docs
title: "Reference: radius.core/recipepacks@2025-08-01-preview"
linkTitle: "recipepacks"
description: "Detailed reference documentation for radius.core/recipepacks@2025-08-01-preview"
---

{{< schemaExample >}}

## Schema

### Top-Level Resource

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **apiVersion** | '2025-08-01-preview' | The resource api version <br />_(ReadOnly, DeployTimeConstant)_ |
| **id** | string | The resource id <br />_(ReadOnly, DeployTimeConstant)_ |
| **location** | string | The geo-location where the resource lives |
| **name** | string | The resource name <br />_(Required, DeployTimeConstant, Identifier)_ |
| **properties** | [RecipePackProperties](#recipepackproperties) | Recipe Pack properties <br />_(Required)_ |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | Provisioning state of the resource at the time the operation was called <br />_(ReadOnly)_ |
| **recipes** | [RecipePackPropertiesRecipes](#recipepackpropertiesrecipes) | Map of resource types to their recipe configurations <br />_(ReadOnly)_ |
| **referencedBy** | string[] | List of environment IDs that reference this recipe pack <br />_(ReadOnly)_ |
| **systemData** | [SystemData](#systemdata) | Metadata pertaining to creation and last modification of the resource. <br />_(ReadOnly)_ |
| **tags** | [TrackedResourceTags](#trackedresourcetags) | Resource tags. |
| **type** | 'Radius.Core/recipePacks' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### RecipePackProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | Provisioning state of the resource at the time the operation was called <br />_(ReadOnly)_ |
| **recipes** | [RecipePackPropertiesRecipes](#recipepackpropertiesrecipes) | Map of resource types to their recipe configurations <br />_(Required)_ |
| **referencedBy** | string[] | List of environment IDs that reference this recipe pack <br />_(ReadOnly)_ |

### RecipePackPropertiesRecipes

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [RecipeDefinition](#recipedefinition)

### RecipeDefinition

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **parameters** | [RecipeDefinitionParameters](#recipedefinitionparameters) | Parameters to pass to the recipe |
| **plainHttp** | bool | Connect to the location using HTTP (not HTTPS). This should be used when the location is known not to support HTTPS, for example in a locally hosted registry for Bicep recipes. Defaults to false (use HTTPS/TLS) |
| **recipeKind** | 'bicep' | 'terraform' | The type of recipe <br />_(Required)_ |
| **recipeLocation** | string | URL path to the recipe <br />_(Required)_ |

### RecipeDefinitionParameters

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: any

### RecipePackPropertiesRecipes

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [RecipeDefinition](#recipedefinition)

### SystemData

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **createdAt** | string | The timestamp of resource creation (UTC). |
| **createdBy** | string | The identity that created the resource. |
| **createdByType** | 'Application' | 'Key' | 'ManagedIdentity' | 'User' | The type of identity that created the resource. |
| **lastModifiedAt** | string | The timestamp of resource last modification (UTC) |
| **lastModifiedBy** | string | The identity that last modified the resource. |
| **lastModifiedByType** | 'Application' | 'Key' | 'ManagedIdentity' | 'User' | The type of identity that created the resource. |

### TrackedResourceTags

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

