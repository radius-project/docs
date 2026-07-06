---
type: docs
title: "Reference: radius.core/environments@2025-08-01-preview"
linkTitle: "environments"
description: "Detailed reference documentation for radius.core/environments@2025-08-01-preview"
---

{{< schemaExample >}}

## Schema

### Top-Level Resource

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **apiVersion** | '2025-08-01-preview' | The resource api version <br />_(ReadOnly, DeployTimeConstant)_ |
| **bicepSettings** | string | Resource ID of a Radius.Core/bicepSettings resource providing Bicep recipe settings. <br />_(ReadOnly)_ |
| **id** | string | The resource id <br />_(ReadOnly, DeployTimeConstant)_ |
| **location** | string | The geo-location where the resource lives |
| **name** | string | The resource name <br />_(Required, DeployTimeConstant, Identifier)_ |
| **properties** | [EnvironmentProperties](#environmentproperties) | The resource-specific properties for this resource. <br />_(Required)_ |
| **providers** | [Providers](#providers) | Cloud provider configuration for the environment. <br />_(ReadOnly)_ |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **recipePacks** | string[] | List of Recipe Pack resource IDs linked to this environment. <br />_(ReadOnly)_ |
| **recipeParameters** | [Record](#record) | Recipe specific parameters that apply to all resources of a given type in this environment. <br />_(ReadOnly)_ |
| **simulated** | bool | Simulated environment. <br />_(ReadOnly)_ |
| **systemData** | [SystemData](#systemdata) | Azure Resource Manager metadata containing createdBy and modifiedBy information. <br />_(ReadOnly)_ |
| **tags** | [Record](#record) | Resource tags. |
| **terraformSettings** | string | Resource ID of a Radius.Core/terraformSettings resource providing Terraform recipe settings. <br />_(ReadOnly)_ |
| **type** | 'Radius.Core/environments' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### EnvironmentProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **bicepSettings** | string | Resource ID of a Radius.Core/bicepSettings resource providing Bicep recipe settings. |
| **providers** | [Providers](#providers) | Cloud provider configuration for the environment. |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **recipePacks** | string[] | List of Recipe Pack resource IDs linked to this environment. |
| **recipeParameters** | [Record](#record) | Recipe specific parameters that apply to all resources of a given type in this environment. |
| **simulated** | bool | Simulated environment. |
| **terraformSettings** | string | Resource ID of a Radius.Core/terraformSettings resource providing Terraform recipe settings. |

### Providers

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **aws** | [ProvidersAws](#providersaws) | The AWS cloud provider configuration. |
| **azure** | [ProvidersAzure](#providersazure) | The Azure cloud provider configuration. |
| **kubernetes** | [ProvidersKubernetes](#providerskubernetes) | The Kubernetes provider configuration. |

### ProvidersAws

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **accountId** | string | AWS account ID for AWS resources to be deployed into. <br />_(Required)_ |
| **region** | string | AWS region for AWS resources to be deployed into. <br />_(Required)_ |

### ProvidersAzure

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **identity** | [IdentitySettings](#identitysettings) | External identity settings (moved from compute). |
| **resourceGroupName** | string | Optional resource group name. |
| **subscriptionId** | string | Azure subscription ID hosting deployed resources. <br />_(Required)_ |

### IdentitySettings

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'azure.com.workload' | 'systemAssigned' | 'systemAssignedUserAssigned' | 'undefined' | 'userAssigned' | kind of identity setting <br />_(Required)_ |
| **managedIdentity** | string[] | The list of user assigned managed identities |
| **oidcIssuer** | string | The URI for your compute platform's OIDC issuer |
| **resource** | string | The resource ID of the provisioned identity |

### ProvidersKubernetes

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **namespace** | string | Kubernetes namespace to deploy workloads into. <br />_(Required)_ |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [RecipeParameterValue](#recipeparametervalue)

### RecipeParameterValue

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: any

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [RecipeParameterValue](#recipeparametervalue)

### RecipeParameterValue

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: any

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

