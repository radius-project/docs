---
type: docs
title: "Reference: applications.core/volumes@2023-10-01-preview"
linkTitle: "volumes"
description: "Detailed reference documentation for applications.core/volumes@2023-10-01-preview"
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
| **properties** | [VolumeProperties](#volumeproperties) | The resource-specific properties for this resource. <br />_(Required)_ |
| **systemData** | [SystemData](#systemdata) | Azure Resource Manager metadata containing createdBy and modifiedBy information. <br />_(ReadOnly)_ |
| **tags** | [Record](#record) | Resource tags. |
| **type** | 'Applications.Core/volumes' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### VolumeProperties

* **Discriminator**: kind

#### Base Properties

| Property | Type | Description |
|----------|------|-------------|
| **application** | string | Fully qualified resource ID for the application <br />_(Required)_ |
| **environment** | string | Fully qualified resource ID for the environment that the application is linked to |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **status** | [ResourceStatus](#resourcestatus) | Status of a resource. <br />_(ReadOnly)_ |

#### AzureKeyVaultVolumeProperties

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **certificates** | [Record](#record) | The KeyVault certificates that this volume exposes |
| **keys** | [Record](#record) | The KeyVault keys that this volume exposes |
| **kind** | 'azure.com.keyvault' | The Azure Key Vault Volume kind <br />_(Required)_ |
| **resource** | string | The ID of the keyvault to use for this volume resource <br />_(Required)_ |
| **secrets** | [Record](#record) | The KeyVault secrets that this volume exposes |


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

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [CertificateObjectProperties](#certificateobjectproperties)

### CertificateObjectProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **alias** | string | File name when written to disk |
| **certType** | 'certificate' | 'privatekey' | 'publickey' | Certificate object type to be downloaded - the certificate itself, private key or public key of the certificate |
| **encoding** | 'base64' | 'hex' | 'utf-8' | Encoding format. Default utf-8 |
| **format** | 'pem' | 'pfx' | Certificate format. Default pem |
| **name** | string | The name of the certificate <br />_(Required)_ |
| **version** | string | Certificate version |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [KeyObjectProperties](#keyobjectproperties)

### KeyObjectProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **alias** | string | File name when written to disk |
| **name** | string | The name of the key <br />_(Required)_ |
| **version** | string | Key version |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [SecretObjectProperties](#secretobjectproperties)

### SecretObjectProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **alias** | string | File name when written to disk |
| **encoding** | 'base64' | 'hex' | 'utf-8' | Encoding format. Default utf-8 |
| **name** | string | The name of the secret <br />_(Required)_ |
| **version** | string | secret version |

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

