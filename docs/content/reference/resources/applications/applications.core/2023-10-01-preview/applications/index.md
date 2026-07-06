---
type: docs
title: "Reference: applications.core/applications@2023-10-01-preview"
linkTitle: "applications"
description: "Detailed reference documentation for applications.core/applications@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

### Top-Level Resource

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **apiVersion** | '2023-10-01-preview' | The resource api version <br />_(ReadOnly, DeployTimeConstant)_ |
| **environment** | string | Fully qualified resource ID for the environment that the application is linked to <br />_(ReadOnly)_ |
| **extensions** | [Extension](#extension)[] | The application extension. <br />_(ReadOnly)_ |
| **id** | string | The resource id <br />_(ReadOnly, DeployTimeConstant)_ |
| **location** | string | The geo-location where the resource lives |
| **name** | string | The resource name <br />_(Required, DeployTimeConstant, Identifier)_ |
| **properties** | [ApplicationProperties](#applicationproperties) | The resource-specific properties for this resource. <br />_(Required)_ |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **status** | [ResourceStatus](#resourcestatus) | Status of a resource. <br />_(ReadOnly)_ |
| **systemData** | [SystemData](#systemdata) | Azure Resource Manager metadata containing createdBy and modifiedBy information. <br />_(ReadOnly)_ |
| **tags** | [Record](#record) | Resource tags. |
| **type** | 'Applications.Core/applications' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### Extension

* **Discriminator**: kind

#### Base Properties

* **none**


#### AzureContainerInstanceExtension

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'aci' | The kind of the resource. <br />_(Required)_ |
| **resourceGroup** | string | The resource group of the application environment. <br />_(Required)_ |

#### DaprSidecarExtension

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **appId** | string | The Dapr appId. Specifies the identifier used by Dapr for service invocation. <br />_(Required)_ |
| **appPort** | int | The Dapr appPort. Specifies the internal listening port for the application to handle requests from the Dapr sidecar.  |
| **config** | string | Specifies the Dapr configuration to use for the resource. |
| **kind** | 'daprSidecar' | Specifies the extension of the resource <br />_(Required)_ |
| **protocol** | 'grpc' | 'http' | Specifies the Dapr app-protocol to use for the resource. |

#### KubernetesMetadataExtension

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **annotations** | [Record](#record) | Annotations to be applied to the Kubernetes resources output by the resource |
| **kind** | 'kubernetesMetadata' | The kind of the resource. <br />_(Required)_ |
| **labels** | [Record](#record) | Labels to be applied to the Kubernetes resources output by the resource |

#### KubernetesNamespaceExtension

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'kubernetesNamespace' | The kind of the resource. <br />_(Required)_ |
| **namespace** | string | The namespace of the application environment. <br />_(Required)_ |

#### ManualScalingExtension

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'manualScaling' | Specifies the extension of the resource <br />_(Required)_ |
| **replicas** | int | Replica count. <br />_(Required)_ |


### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

### ApplicationProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **environment** | string | Fully qualified resource ID for the environment that the application is linked to <br />_(Required)_ |
| **extensions** | [Extension](#extension)[] | The application extension. |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **status** | [ResourceStatus](#resourcestatus) | Status of a resource. <br />_(ReadOnly)_ |

### ResourceStatus

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **compute** | [EnvironmentCompute](#environmentcompute) | The compute resource associated with the resource. |
| **outputResources** | [OutputResource](#outputresource)[] | Properties of an output resource |
| **recipe** | [RecipeStatus](#recipestatus) | The recipe data at the time of deployment <br />_(ReadOnly)_ |

### EnvironmentCompute

* **Discriminator**: kind

#### Base Properties

| Property | Type | Description |
|----------|------|-------------|
| **identity** | [IdentitySettings](#identitysettings) | Configuration for supported external identity providers |
| **resourceId** | string | The resource id of the compute resource for application environment. |

#### AzureContainerInstanceCompute

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'aci' | The Azure container instance compute kind <br />_(Required)_ |
| **resourceGroup** | string | The resource group to use for the environment. |

#### KubernetesCompute

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'kubernetes' | The Kubernetes compute kind <br />_(Required)_ |
| **namespace** | string | The namespace to use for the environment. <br />_(Required)_ |


### IdentitySettings

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'azure.com.workload' | 'systemAssigned' | 'systemAssignedUserAssigned' | 'undefined' | 'userAssigned' | kind of identity setting <br />_(Required)_ |
| **managedIdentity** | string[] | The list of user assigned managed identities |
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
| **lastModifiedByType** | 'Application' | 'Key' | 'ManagedIdentity' | 'User' | The type of identity that last modified the resource. |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

