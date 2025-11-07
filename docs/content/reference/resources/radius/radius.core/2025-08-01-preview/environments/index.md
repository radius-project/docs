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
| **id** | string | The resource id <br />_(ReadOnly, DeployTimeConstant)_ |
| **location** | string | The geo-location where the resource lives |
| **name** | string | The resource name <br />_(Required, DeployTimeConstant, Identifier)_ |
| **properties** | [EnvironmentProperties](#environmentproperties) | Environment properties <br />_(Required)_ |
| **systemData** | [SystemData](#systemdata) | Metadata pertaining to creation and last modification of the resource. <br />_(ReadOnly)_ |
| **tags** | [TrackedResourceTags](#trackedresourcetags) | Resource tags. |
| **type** | 'Radius.Core/environments' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### EnvironmentProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **providers** | [Providers](#providers) |  |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | Provisioning state of the resource at the time the operation was called <br />_(ReadOnly)_ |
| **recipePacks** | string[] | List of Recipe Pack resource IDs linked to this environment. |
| **simulated** | bool | Simulated environment. |

### Providers

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **aws** | [ProvidersAws](#providersaws) | The AWS cloud provider definition. |
| **azure** | [ProvidersAzure](#providersazure) | The Azure cloud provider definition. |
| **kubernetes** | [ProvidersKubernetes](#providerskubernetes) |  |

### ProvidersAws

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **scope** | string | Target scope for AWS resources to be deployed into.  For example: '/planes/aws/aws/accounts/000000000000/regions/us-west-2'. <br />_(Required)_ |

### ProvidersAzure

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **identity** | [IdentitySettings](#identitysettings) | IdentitySettings is the external identity setting. |
| **resourceGroupName** | string | Optional resource group name. |
| **subscriptionId** | string | Azure subscription ID hosting deployed resources. <br />_(Required)_ |

### IdentitySettings

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'azure.com.workload' | 'systemAssigned' | 'systemAssignedUserAssigned' | 'undefined' | 'userAssigned' | IdentitySettingKind is the kind of supported external identity setting <br />_(Required)_ |
| **managedIdentity** | string[] | The list of user assigned managed identities |
| **oidcIssuer** | string | The URI for your compute platform's OIDC issuer |
| **resource** | string | The resource ID of the provisioned identity |

### ProvidersKubernetes

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **namespace** | string | Kubernetes namespace to deploy workloads into. <br />_(Required)_ |

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

