---
type: docs
title: "Reference: radius.core/terraformconfigs@2025-08-01-preview"
linkTitle: "terraformconfigs"
description: "Detailed reference documentation for radius.core/terraformconfigs@2025-08-01-preview"
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
| **properties** | [TerraformConfigProperties](#terraformconfigproperties) | Terraform configuration properties. <br />_(Required)_ |
| **systemData** | [SystemData](#systemdata) | Metadata pertaining to creation and last modification of the resource. <br />_(ReadOnly)_ |
| **tags** | [TrackedResourceTags](#trackedresourcetags) | Resource tags. |
| **type** | 'Radius.Core/terraformConfigs' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

### TerraformConfigProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **env** | [TerraformConfigPropertiesEnv](#terraformconfigpropertiesenv) | Environment variables injected during Terraform recipe execution. |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | Provisioning state of the resource at the time the operation was called <br />_(ReadOnly)_ |
| **referencedBy** | string[] | Environments that reference this Terraform configuration. <br />_(ReadOnly)_ |
| **terraformrc** | [TerraformrcConfig](#terraformrcconfig) | Terraform CLI configuration file (.terraformrc) settings. See https://developer.hashicorp.com/terraform/cli/config for details. |

### TerraformConfigPropertiesEnv

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

### TerraformrcConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **credentials** | [TerraformrcConfigCredentials](#terraformrcconfigcredentials) | Credentials for authenticating to private Terraform registries (HTTP-based, e.g. app.terraform.io). Map of registry hostname to credential configuration. Rendered as native `credentials "hostname" {}` blocks in the generated .terraformrc. Note: this is for Terraform CLI registry auth (HTTP), not for Git-based module sources; Git auth is a separate mechanism. |
| **providerInstallation** | [TerraformProviderInstallation](#terraformproviderinstallation) | Provider installation configuration for Terraform CLI. |

### TerraformrcConfigCredentials

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [TerraformCredentialConfig](#terraformcredentialconfig)

### TerraformCredentialConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **secret** | string | The ID of an Applications.Core/SecretStore resource containing the authentication token. The secret store must have a secret named 'token'. |

### TerraformProviderInstallation

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **direct** | [TerraformProviderDirect](#terraformproviderdirect) | Direct provider installation configuration. |
| **networkMirror** | [TerraformProviderMirror](#terraformprovidermirror) | Network mirror configuration for Terraform providers. |

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
| **lastModifiedByType** | 'Application' | 'Key' | 'ManagedIdentity' | 'User' | The type of identity that created the resource. |

### TrackedResourceTags

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

