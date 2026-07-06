---
type: docs
title: "Reference: radius.core/terraformsettings@2025-08-01-preview"
linkTitle: "terraformsettings"
description: "Detailed reference documentation for radius.core/terraformsettings@2025-08-01-preview"
---

{{< schemaExample >}}

## Schema

### Top-Level Resource

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **apiVersion** | '2025-08-01-preview' | The resource api version <br />_(ReadOnly, DeployTimeConstant)_ |
| **env** | [Record](#record) | Environment variables injected during Terraform recipe execution. <br />_(ReadOnly)_ |
| **id** | string | The resource id <br />_(ReadOnly, DeployTimeConstant)_ |
| **location** | string | The geo-location where the resource lives |
| **name** | string | The resource name <br />_(Required, DeployTimeConstant, Identifier)_ |
| **properties** | [TerraformSettingsProperties](#terraformsettingsproperties) | The resource-specific properties for this resource. <br />_(Required)_ |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **referencedBy** | string[] | Environments that reference this Terraform configuration. <br />_(ReadOnly)_ |
| **systemData** | [SystemData](#systemdata) | Azure Resource Manager metadata containing createdBy and modifiedBy information. <br />_(ReadOnly)_ |
| **tags** | [Record](#record) | Resource tags. |
| **terraformrc** | [TerraformrcConfig](#terraformrcconfig) | Terraform CLI configuration file settings. Maps directly to the Terraform CLI configuration file (.terraformrc). <br />_(ReadOnly)_ |
| **type** | 'Radius.Core/terraformSettings' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

### TerraformSettingsProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **env** | [Record](#record) | Environment variables injected during Terraform recipe execution. |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **referencedBy** | string[] | Environments that reference this Terraform configuration. <br />_(ReadOnly)_ |
| **terraformrc** | [TerraformrcConfig](#terraformrcconfig) | Terraform CLI configuration file settings. Maps directly to the Terraform CLI configuration file (.terraformrc). |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

### TerraformrcConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **credentials** | [Record](#record) | Credentials for authenticating to private Terraform registries (HTTP-based, e.g. app.terraform.io). Map of registry hostname to credential configuration. Rendered as native `credentials "hostname" {}` blocks in the generated .terraformrc. Note: this is for Terraform CLI registry auth (HTTP), not for Git-based module sources; Git auth is a separate mechanism. |
| **providerInstallation** | [TerraformProviderInstallation](#terraformproviderinstallation) | Provider installation configuration. Specifies the location of providers via network mirrors or direct downloads. |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [TerraformCredentialConfig](#terraformcredentialconfig)

### TerraformCredentialConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **secret** | string | The ID of a secret resource containing the authentication token. Supported types: Radius.Security/secrets (recommended) or Applications.Core/secretStores. The secret must have a key named 'token'. |

### TerraformProviderInstallation

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **direct** | [TerraformProviderDirect](#terraformproviderdirect) | Direct provider installation configuration. |
| **networkMirror** | [TerraformProviderMirror](#terraformprovidermirror) | Network mirror configuration for downloading providers. |

### TerraformProviderDirect

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **exclude** | string[] | Provider address patterns to exclude from direct installation. |
| **include** | string[] | Provider address patterns to include for direct installation. |

### TerraformProviderMirror

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **exclude** | string[] | Provider address patterns to exclude from this mirror. |
| **include** | string[] | Provider address patterns to include from this mirror. |
| **url** | string | The URL of the provider mirror. |

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

