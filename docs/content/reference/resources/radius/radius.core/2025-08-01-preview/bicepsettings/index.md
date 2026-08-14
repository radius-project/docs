---
type: docs
title: "Reference: radius.core/bicepsettings@2025-08-01-preview"
linkTitle: "bicepsettings"
description: "Detailed reference documentation for radius.core/bicepsettings@2025-08-01-preview"
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
| **properties** | [BicepSettingsProperties](#bicepsettingsproperties) | The resource-specific properties for this resource. <br />_(Required)_ |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **referencedBy** | string[] | Environments that reference this Bicep configuration. <br />_(ReadOnly)_ |
| **registryAuthentications** | [Record](#record) | Authentication configuration for private Bicep registries, keyed by registry hostname (e.g. 'corp.acr.io'). The Bicep driver looks up credentials by the host parsed from the recipe template path. <br />_(ReadOnly)_ |
| **systemData** | [SystemData](#systemdata) | Azure Resource Manager metadata containing createdBy and modifiedBy information. <br />_(ReadOnly)_ |
| **tags** | [Record](#record) | Resource tags. |
| **type** | 'Radius.Core/bicepSettings' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### BicepSettingsProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **referencedBy** | string[] | Environments that reference this Bicep configuration. <br />_(ReadOnly)_ |
| **registryAuthentications** | [Record](#record) | Authentication configuration for private Bicep registries, keyed by registry hostname (e.g. 'corp.acr.io'). The Bicep driver looks up credentials by the host parsed from the recipe template path. |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [BicepRegistryAuthentication](#bicepregistryauthentication)

### BicepRegistryAuthentication

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **authenticationMethod** | 'AwsIrsa' | 'AzureWI' | 'BasicAuth' | The authentication method to use. Supported values: BasicAuth, AzureWI, AwsIrsa. |
| **awsIamRoleArn** | string | AWS IAM Role ARN for IRSA authentication. Required when authenticationMethod is 'AwsIrsa'. |
| **azureWiClientId** | string | Azure Workload Identity client ID. Required when authenticationMethod is 'AzureWI'. |
| **azureWiTenantId** | string | Azure Workload Identity tenant ID. Required when authenticationMethod is 'AzureWI'. |
| **basicAuthSecretId** | string | The ID of a secret resource containing username and password for BasicAuth. Supported types: Radius.Security/secrets (recommended) or Applications.Core/secretStores. Required when authenticationMethod is 'BasicAuth'. |

### Record

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
| **lastModifiedByType** | 'Application' | 'Key' | 'ManagedIdentity' | 'User' | The type of identity that last modified the resource. |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

