---
type: docs
title: "Reference: applications.dapr/pubsubbrokers@2023-10-01-preview"
linkTitle: "pubsubbrokers"
description: "Detailed reference documentation for applications.dapr/pubsubbrokers@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

### Top-Level Resource

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **apiVersion** | '2023-10-01-preview' | The resource api version <br />_(ReadOnly, DeployTimeConstant)_ |
| **id** | string | The resource id <br />_(ReadOnly, DeployTimeConstant)_ |
| **location** | string | The geo-location where the resource lives |
| **name** | string | The resource name <br />_(Required, DeployTimeConstant, Identifier)_ |
| **properties** | [DaprPubSubBrokerProperties](#daprpubsubbrokerproperties) | Dapr PubSubBroker portable resource properties <br />_(Required)_ |
| **systemData** | [SystemData](#systemdata) | Metadata pertaining to creation and last modification of the resource. <br />_(ReadOnly)_ |
| **tags** | [TrackedResourceTags](#trackedresourcetags) | Resource tags. |
| **type** | 'Applications.Dapr/pubSubBrokers' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### DaprPubSubBrokerProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **application** | string | Fully qualified resource ID for the application that the portable resource is consumed by (if applicable) |
| **auth** | [DaprResourceAuth](#daprresourceauth) | Authentication properties for a Dapr component object |
| **componentName** | string | The name of the Dapr component object. Use this value in your code when interacting with the Dapr client to use the Dapr component. <br />_(ReadOnly)_ |
| **environment** | string | Fully qualified resource ID for the environment that the portable resource is linked to <br />_(Required)_ |
| **metadata** | [DaprPubSubBrokerPropertiesMetadata](#daprpubsubbrokerpropertiesmetadata) | The metadata for Dapr resource which must match the values specified in Dapr component spec |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | Provisioning state of the resource at the time the operation was called <br />_(ReadOnly)_ |
| **recipe** | [Recipe](#recipe) | The recipe used to automatically deploy underlying infrastructure for a portable resource |
| **resourceProvisioning** | 'manual' | 'recipe' | Specifies how the underlying service/resource is provisioned and managed. Available values are 'recipe', where Radius manages the lifecycle of the resource through a Recipe, and 'manual', where a user manages the resource and provides the values. |
| **resources** | [ResourceReference](#resourcereference)[] | A collection of references to resources associated with the pubSubBroker |
| **status** | [ResourceStatus](#resourcestatus) | Status of a resource. <br />_(ReadOnly)_ |
| **type** | string | Dapr component type which must matches the format used by Dapr Kubernetes configuration format |
| **version** | string | Dapr component version |

### DaprResourceAuth

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **secretStore** | string | Secret store to fetch secrets from |

### DaprPubSubBrokerPropertiesMetadata

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [MetadataValue](#metadatavalue)

### MetadataValue

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **secretKeyRef** | [MetadataValueFromSecret](#metadatavaluefromsecret) | A reference of a value in a secret store component. |
| **value** | string | The plain text value of the metadata |

### MetadataValueFromSecret

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **key** | string | The field to select in the secret value. If the secret value is a string, it should be equal to the secret name <br />_(Required)_ |
| **name** | string | Secret name in the secret store component <br />_(Required)_ |

### Recipe

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **name** | string | The name of the recipe within the environment to use <br />_(Required)_ |
| **parameters** | any | Any object |

### ResourceReference

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **id** | string | Resource id of an existing resource <br />_(Required)_ |

### ResourceStatus

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **compute** | [EnvironmentCompute](#environmentcompute) | Represents backing compute resource |
| **outputResources** | [OutputResource](#outputresource)[] | Properties of an output resource |
| **recipe** | [RecipeStatus](#recipestatus) | Recipe status at deployment time for a resource. <br />_(ReadOnly)_ |

### EnvironmentCompute

* **Discriminator**: kind

#### Base Properties

| Property | Type | Description |
|----------|------|-------------|
| **identity** | [IdentitySettings](#identitysettings) | IdentitySettings is the external identity setting. |
| **resourceId** | string | The resource id of the compute resource for application environment. |

#### KubernetesCompute

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'kubernetes' | Discriminator property for EnvironmentCompute. <br />_(Required)_ |
| **namespace** | string | The namespace to use for the environment. <br />_(Required)_ |


### IdentitySettings

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'azure.com.workload' | 'undefined' | IdentitySettingKind is the kind of supported external identity setting <br />_(Required)_ |
| **oidcIssuer** | string | The URI for your compute platform's OIDC issuer |
| **resource** | string | The resource ID of the provisioned identity |

### OutputResource

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **id** | string | The UCP resource ID of the underlying resource. |
| **localId** | string | The logical identifier scoped to the owning Radius resource. This is only needed or used when a resource has a dependency relationship. LocalIDs do not have any particular format or meaning beyond being compared to determine dependency relationships. |
| **radiusManaged** | bool | Determines whether Radius manages the lifecycle of the underlying resource. |

### RecipeStatus

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **templateKind** | string | TemplateKind is the kind of the recipe template used by the portable resource upon deployment. <br />_(Required)_ |
| **templatePath** | string | TemplatePath is the path of the recipe consumed by the portable resource upon deployment. <br />_(Required)_ |
| **templateVersion** | string | TemplateVersion is the version number of the template. |

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

