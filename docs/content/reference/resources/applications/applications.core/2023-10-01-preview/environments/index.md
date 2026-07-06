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
| **apiVersion** | '2023-10-01-preview' | The resource api version <br />_(ReadOnly, DeployTimeConstant)_ |
| **compute** | [EnvironmentCompute](#environmentcompute) | The compute resource used by application environment. <br />_(ReadOnly)_ |
| **extensions** | [Extension](#extension)[] | The environment extension. <br />_(ReadOnly)_ |
| **id** | string | The resource id <br />_(ReadOnly, DeployTimeConstant)_ |
| **location** | string | The geo-location where the resource lives |
| **name** | string | The resource name <br />_(Required, DeployTimeConstant, Identifier)_ |
| **properties** | [EnvironmentProperties](#environmentproperties) | The resource-specific properties for this resource. <br />_(Required)_ |
| **providers** | [Providers](#providers) | Cloud providers configuration for the environment. <br />_(ReadOnly)_ |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **recipeConfig** | [RecipeConfigProperties](#recipeconfigproperties) | Configuration for Recipes. Defines how each type of Recipe should be configured and run. <br />_(ReadOnly)_ |
| **recipes** | [Record](#record) | Specifies Recipes linked to the Environment. <br />_(ReadOnly)_ |
| **simulated** | bool | Simulated environment. <br />_(ReadOnly)_ |
| **systemData** | [SystemData](#systemdata) | Azure Resource Manager metadata containing createdBy and modifiedBy information. <br />_(ReadOnly)_ |
| **tags** | [Record](#record) | Resource tags. |
| **type** | 'Applications.Core/environments' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |

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

### EnvironmentProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **compute** | [EnvironmentCompute](#environmentcompute) | The compute resource used by application environment. <br />_(Required)_ |
| **extensions** | [Extension](#extension)[] | The environment extension. |
| **providers** | [Providers](#providers) | Cloud providers configuration for the environment. |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **recipeConfig** | [RecipeConfigProperties](#recipeconfigproperties) | Configuration for Recipes. Defines how each type of Recipe should be configured and run. |
| **recipes** | [Record](#record) | Specifies Recipes linked to the Environment. |
| **simulated** | bool | Simulated environment. |

### Providers

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **aws** | [ProvidersAws](#providersaws) | The AWS cloud provider configuration. |
| **azure** | [ProvidersAzure](#providersazure) | The Azure cloud provider configuration. |

### ProvidersAws

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **scope** | string | Target scope for AWS resources to be deployed into.  For example: '/planes/aws/aws/accounts/000000000000/regions/us-west-2'. <br />_(Required)_ |

### ProvidersAzure

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **scope** | string | Target scope for Azure resources to be deployed into.  For example: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/testGroup'. <br />_(Required)_ |

### RecipeConfigProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **bicep** | [BicepConfigProperties](#bicepconfigproperties) | Configuration for Bicep Recipes. Controls how Bicep plans and applies templates as part of Recipe deployment. |
| **env** | [EnvironmentVariables](#environmentvariables) | Environment variables injected during recipe execution for the recipes in the environment, currently supported for Terraform recipes. |
| **envSecrets** | [Record](#record) | Environment variables containing sensitive information can be stored as secrets. The secrets are stored in Applications.Core/SecretStores resource. |
| **terraform** | [TerraformConfigProperties](#terraformconfigproperties) | Configuration for Terraform Recipes. Controls how Terraform plans and applies templates as part of Recipe deployment. |

### BicepConfigProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **authentication** | [Record](#record) | Authentication information used to access private bicep registries, which is a map of registry hostname to secret config that contains credential information. |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [RegistrySecretConfig](#registrysecretconfig)

### RegistrySecretConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **secret** | string | The ID of an Applications.Core/SecretStore resource containing credential information used to authenticate private container registry.The keys in the secretstore depends on the type. |

### EnvironmentVariables

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: string

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [SecretReference](#secretreference)

### SecretReference

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **key** | string | The key for the secret in the secret store. <br />_(Required)_ |
| **source** | string | The ID of an Applications.Core/SecretStore resource containing sensitive data required for recipe execution. <br />_(Required)_ |

### TerraformConfigProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **authentication** | [AuthConfig](#authconfig) | Authentication information used to access private Terraform module sources. Supported module sources: Git. |
| **providers** | [Record](#record) | Configuration for Terraform Recipe Providers. Controls how Terraform interacts with cloud providers, SaaS providers, and other APIs. For more information, please see: https://developer.hashicorp.com/terraform/language/providers/configuration. |

### AuthConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **git** | [GitAuthConfig](#gitauthconfig) | Authentication information used to access private Terraform modules from Git repository sources. |

### GitAuthConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **pat** | [Record](#record) | Personal Access Token (PAT) configuration used to authenticate to Git platforms. |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [SecretConfig](#secretconfig)

### SecretConfig

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **secret** | string | The ID of an Applications.Core/SecretStore resource containing the Git platform personal access token (PAT). The secret store must have a secret named 'pat', containing the PAT value. A secret named 'username' is optional, containing the username associated with the pat. By default no username is specified. |

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [ProviderConfigProperties](#providerconfigproperties)[]

### ProviderConfigProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **secrets** | [Record](#record) | Sensitive data in provider configuration can be stored as secrets. The secrets are stored in Applications.Core/SecretStores resource. |
#### Additional Properties

* **Additional Properties Type**: any

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [SecretReference](#secretreference)

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [Record](#record)

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [RecipeProperties](#recipeproperties)

### RecipeProperties

* **Discriminator**: templateKind

#### Base Properties

| Property | Type | Description |
|----------|------|-------------|
| **parameters** | [Record](#record) | Key/value parameters to pass to the recipe template at deployment. |
| **templatePath** | string | Path to the template provided by the recipe. Currently only link to Azure Container Registry is supported. <br />_(Required)_ |

#### BicepRecipeProperties

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **plainHttp** | bool | Connect to the Bicep registry using HTTP (not-HTTPS). This should be used when the registry is known not to support HTTPS, for example in a locally-hosted registry. Defaults to false (use HTTPS/TLS). |
| **templateKind** | 'bicep' | The Bicep template kind. <br />_(Required)_ |

#### TerraformRecipeProperties

##### Properties

| Property | Type | Description |
|----------|------|-------------|
| **templateKind** | 'terraform' | The Terraform template kind. <br />_(Required)_ |
| **templateVersion** | string | Version of the template to deploy. For Terraform recipes using a module registry this is required, but must be omitted for other module sources. |


### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: any

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [Record](#record)

### Record

#### Properties

* **none**

#### Additional Properties

* **Additional Properties Type**: [RecipeProperties](#recipeproperties)

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

