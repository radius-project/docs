---
type: docs
title: "Reference: radius.core/bicepconfigs@2025-08-01-preview"
linkTitle: "bicepconfigs"
description: "Detailed reference documentation for radius.core/bicepconfigs@2025-08-01-preview"
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
| **properties** | [BicepConfigProperties](#bicepconfigproperties) | Bicep configuration properties. <br />_(Required)_ |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | Provisioning state of the resource at the time the operation was called <br />_(ReadOnly)_ |
| **referencedBy** | string[] | Environments that reference this Bicep configuration. <br />_(ReadOnly)_ |
| **registryAuthentications** | [BicepConfigPropertiesRegistryAuthentications](#bicepconfigpropertiesregistryauthentications) | Authentication configuration for private Bicep registries, keyed by registry hostname (e.g. 'corp.acr.io'). The Bicep driver looks up credentials by the host parsed from the recipe template path. <br />_(ReadOnly)_ |
| **systemData** | [SystemData](#systemdata) | Metadata pertaining to creation and last modification of the resource. <br />_(ReadOnly)_ |
| **tags** | [TrackedResourceTags](#trackedresourcetags) | Resource tags. |
| **type** | 'Radius.Core/bicepConfigs' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### BicepConfigProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | Provisioning state of the resource at the time the operation was called <br />_(ReadOnly)_ |
| **referencedBy** | string[] | Environments that reference this Bicep configuration. <br />_(ReadOnly)_ |
| **registryAuthentications** | [BicepConfigPropertiesRegistryAuthentications](#bicepconfigpropertiesregistryauthentications) | Authentication configuration for private Bicep registries, keyed by registry hostname (e.g. 'corp.acr.io'). The Bicep driver looks up credentials by the host parsed from the recipe template path. |

### BicepConfigPropertiesRegistryAuthentications

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [BicepRegistryAuthentication](#bicepregistryauthentication)

### BicepRegistryAuthentication

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **authenticationMethod** | 'AwsIrsa' | 'AzureWI' | 'BasicAuth' | Supported authentication methods for private Bicep registries. |
| **awsIamRoleArn** | string | AWS IAM Role ARN for IRSA authentication. Required when authenticationMethod is 'AwsIrsa'. |
| **azureWiClientId** | string | Azure Workload Identity client ID. Required when authenticationMethod is 'AzureWI'. |
| **azureWiTenantId** | string | Azure Workload Identity tenant ID. Required when authenticationMethod is 'AzureWI'. |
| **basicAuthSecretId** | string | The ID of an Applications.Core/SecretStore resource containing username and password for BasicAuth. Required when authenticationMethod is 'BasicAuth'. |

### BicepConfigPropertiesRegistryAuthentications

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [BicepRegistryAuthentication](#bicepregistryauthentication)

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

