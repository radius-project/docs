---
type: docs
title: "Reference: applications.core/environments@2023-10-01-preview"
linkTitle: "environments"
description: "Detailed reference documentation for applications.core/environments@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

### Top-Level Resource

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **apiVersion** | '2023-10-01-preview' | The resource api version <br />_(read-only, deploy-time constant)_ |
| **id** | string | The resource id <br />_(read-only, deploy-time constant)_ |
| **location** | string | The geo-location where the resource lives <br />_(required)_ |
| **name** | string | The resource name <br />_(required, deploy-time constant)_ |
| **properties** | [EnvironmentProperties](#environmentproperties) | Environment properties <br />_(required)_ |
| **systemData** | [SystemData](#systemdata) | Metadata pertaining to creation and last modification of the resource. <br />_(read-only)_ |
| **tags** | [TrackedResourceTags](#trackedresourcetags) | Resource tags. |
| **type** | 'Applications.Core/environments' | The resource type <br />_(read-only, deploy-time constant)_ |

### EnvironmentProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **compute** | [EnvironmentCompute](#environmentcompute) | Represents backing compute resource <br />_(required)_ |
| **extensions** | [Extension](#extension)[] | The environment extension. |
| **providers** | [Providers](#providers) | The Cloud providers configuration. |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | Provisioning state of the resource at the time the operation was called <br />_(read-only)_ |
| **recipeConfig** | [RecipeConfigProperties](#recipeconfigproperties) | Configuration for Recipes. Defines how each type of Recipe should be configured and run. |
| **recipes** | [EnvironmentPropertiesRecipes](#environmentpropertiesrecipes) | Specifies Recipes linked to the Environment. |
| **simulated** | bool | Simulated environment. |

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
| **kind** | 'kubernetes' | Discriminator property for EnvironmentCompute. <br />_(required)_ |
| **namespace** | string | The namespace to use for the environment. <br />_(required)_ |


### IdentitySettings

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'azure.com.workload' | 'undefined' | IdentitySettingKind is the kind of supported external identity setting <br />_(required)_ |
| **oidcIssuer** | string | The URI for your compute platform's OIDC issuer |
| **resource** | string | The resource ID of the provisioned identity |

### Extension

* **Discriminator**: kind

#### Base Properties

* **none**


#### DaprSidecarExtension

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **appId** | string | The Dapr appId. Specifies the identifier used by Dapr for service invocation. <br />_(required)_ |
| **appPort** | int | The Dapr appPort. Specifies the internal listening port for the application to handle requests from the Dapr sidecar. |
| **config** | string | Specifies the Dapr configuration to use for the resource. |
| **kind** | 'daprSidecar' | Discriminator property for Extension. <br />_(required)_ |
| **protocol** | 'grpc' | 'http' | The Dapr sidecar extension protocol |

#### KubernetesMetadataExtension

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **annotations** | [KubernetesMetadataExtensionAnnotations](#kubernetesmetadataextensionannotations) | Annotations to be applied to the Kubernetes resources output by the resource |
| **kind** | 'kubernetesMetadata' | Discriminator property for Extension. <br />_(required)_ |
| **labels** | [KubernetesMetadataExtensionLabels](#kubernetesmetadataextensionlabels) | Labels to be applied to the Kubernetes resources output by the resource |

#### KubernetesNamespaceExtension

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'kubernetesNamespace' | Discriminator property for Extension. <br />_(required)_ |
| **namespace** | string | The namespace of the application environment. <br />_(required)_ |

#### ManualScalingExtension

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **kind** | 'manualScaling' | Discriminator property for Extension. <br />_(required)_ |
| **replicas** | int | Replica count. <br />_(required)_ |


### KubernetesMetadataExtensionAnnotations

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

### KubernetesMetadataExtensionLabels

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

### Providers

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **aws** | [ProvidersAws](#providersaws) | The AWS cloud provider definition. |
| **azure** | [ProvidersAzure](#providersazure) | The Azure cloud provider definition. |

### ProvidersAws

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **scope** | string | Target scope for AWS resources to be deployed into.  For example: '/planes/aws/aws/accounts/000000000000/regions/us-west-2'. <br />_(required)_ |

### ProvidersAzure

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **scope** | string | Target scope for Azure resources to be deployed into.  For example: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/testGroup'. <br />_(required)_ |

### RecipeConfigProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **env** | [EnvironmentVariables](#environmentvariables) | The environment variables injected during Terraform Recipe execution for the recipes in the environment. |
| **envSecrets** | [RecipeConfigPropertiesEnvSecrets](#recipeconfigpropertiesenvsecrets) | Environment variables containing sensitive information can be stored as secrets. The secrets are stored in Applications.Core/SecretStores resource. |
| **terraform** | [TerraformConfigProperties](#terraformconfigproperties) | Configuration for Terraform Recipes. Controls how Terraform plans and applies templates as part of Recipe deployment. |

### EnvironmentVariables

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

### RecipeConfigPropertiesEnvSecrets

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [SecretReference](#secretreference)

### SecretReference

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **key** | string | The key for the secret in the secret store. <br />_(required)_ |
| **source** | string | The ID of an Applications.Core/SecretStore resource containing sensitive data required for recipe execution. <br />_(required)_ |

### TerraformConfigProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **authentication** | [AuthConfig](#authconfig) | Authentication information used to access private Terraform module sources. Supported module sources: Git. |
| **providers** | [TerraformConfigPropertiesProviders](#terraformconfigpropertiesproviders) | Configuration for Terraform Recipe Providers. Controls how Terraform interacts with cloud providers, SaaS providers, and other APIs. For more information, please see: https://developer.hashicorp.com/terraform/language/providers/configuration. |

### AuthConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **git** | [GitAuthConfig](#gitauthconfig) | Authentication information used to access private Terraform modules from Git repository sources. |

### GitAuthConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **pat** | [GitAuthConfigPat](#gitauthconfigpat) | Personal Access Token (PAT) configuration used to authenticate to Git platforms. |

### GitAuthConfigPat

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [SecretConfig](#secretconfig)

### SecretConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **secret** | string | The ID of an Applications.Core/SecretStore resource containing the Git platform personal access token (PAT). The secret store must have a secret named 'pat', containing the PAT value. A secret named 'username' is optional, containing the username associated with the pat. By default no username is specified. |

### TerraformConfigPropertiesProviders

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [ProviderConfigProperties](#providerconfigproperties)[]

### ProviderConfigProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **secrets** | [ProviderConfigPropertiesSecrets](#providerconfigpropertiessecrets) | Sensitive data in provider configuration can be stored as secrets. The secrets are stored in Applications.Core/SecretStores resource. |
#### Additional Properties

* **Additional Properties Type**: any

### ProviderConfigPropertiesSecrets

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [SecretReference](#secretreference)

### EnvironmentPropertiesRecipes

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [DictionaryOfRecipeProperties](#dictionaryofrecipeproperties)

### DictionaryOfRecipeProperties

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [RecipeProperties](#recipeproperties)

### RecipeProperties

* **Discriminator**: templateKind

#### Base Properties

| Property | Type | Description |
|----------|------|-------------|
| **parameters** | any | Any object |
| **templatePath** | string | Path to the template provided by the recipe. Currently only link to Azure Container Registry is supported. <br />_(required)_ |

#### BicepRecipeProperties

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **plainHttp** | bool | Connect to the Bicep registry using HTTP (not-HTTPS). This should be used when the registry is known not to support HTTPS, for example in a locally-hosted registry. Defaults to false (use HTTPS/TLS). |
| **templateKind** | 'bicep' | Discriminator property for RecipeProperties. <br />_(required)_ |

#### TerraformRecipeProperties

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **templateKind** | 'terraform' | Discriminator property for RecipeProperties. <br />_(required)_ |
| **templateVersion** | string | Version of the template to deploy. For Terraform recipes using a module registry this is required, but must be omitted for other module sources. |


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

