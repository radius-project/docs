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
| **properties** | [RecipePackProperties](#recipepackproperties) | The resource-specific properties for this resource. <br />_(Required)_ |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation <br />_(ReadOnly)_ |
| **recipes** | [Record](#record) | Map of resource types to their recipe configurations <br />_(ReadOnly)_ |
| **referencedBy** | string[] | List of environment IDs that reference this recipe pack <br />_(ReadOnly)_ |
| **systemData** | [SystemData](#systemdata) | Azure Resource Manager metadata containing createdBy and modifiedBy information. <br />_(ReadOnly)_ |
| **tags** | [Record](#record) | Resource tags. |
| **type** | 'Radius.Core/recipePacks' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### RecipePackProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation <br />_(ReadOnly)_ |
| **recipes** | [Record](#record) | Map of resource types to their recipe configurations <br />_(Required)_ |
| **referencedBy** | string[] | List of environment IDs that reference this recipe pack <br />_(ReadOnly)_ |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [RecipeDefinition](#recipedefinition)

### RecipeDefinition

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'bicep' | 'terraform' | The type of recipe (e.g., Terraform, Bicep) <br />_(Required)_ |
| **outputs** | [Record](#record) | Map of resource type property names to module output names. Used for recipes that point directly at a Bicep or Terraform module to map the module's outputs onto the resource's properties. |
| **parameters** | [Record](#record) | Parameters to pass to the recipe |
| **plainHttp** | bool | Connect to the source using HTTP (not HTTPS). This should be used when the source is known not to support HTTPS, for example in a locally hosted registry for Bicep recipes. Defaults to false (use HTTPS/TLS) |
| **source** | string | The source of the recipe. For Bicep recipes this is the OCI registry reference. For Terraform recipes this is the module source. <br />_(Required)_ |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: any

### Record

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
| **lastModifiedByType** | 'Application' | 'Key' | 'ManagedIdentity' | 'User' | The type of identity that last modified the resource. |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

