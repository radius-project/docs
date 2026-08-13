---
type: docs
title: "Reference: applications.core/environments@2023-10-01-preview"
linkTitle: "environments"
description: "Detailed reference documentation for applications.core/environments@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

The environment resource

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `compute` | [object](#compute) | true | false | The compute resource used by application environment. |
| `extensions` | [object](#extensions)[] | false | false | The environment extension. |
| `providers` | [object](#providers) | false | false | Cloud providers configuration for the environment. |
| `provisioningState` | string | false | true | The status of the asynchronous operation.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `recipeConfig` | [object](#recipeconfig) | false | false | Configuration for Recipes. Defines how each type of Recipe should be configured and run. |
| `recipes` | [object](#recipes) | false | false | Specifies Recipes linked to the Environment. |
| `simulated` | boolean | false | false | Simulated environment. |

## Object Properties

### `compute` {#compute}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`aci`](#compute-aci), [`kubernetes`](#compute-kubernetes). |
| `identity` | [object](#compute-identity) | false | false | Configuration for supported external identity providers |
| `resourceId` | string | false | false | The resource id of the compute resource for application environment. |

### `extensions` {#extensions}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`aci`](#extensions-aci), [`daprSidecar`](#extensions-daprsidecar), [`kubernetesMetadata`](#extensions-kubernetesmetadata), [`kubernetesNamespace`](#extensions-kubernetesnamespace), [`manualScaling`](#extensions-manualscaling). |

### `providers` {#providers}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `aws` | [object](#providers-aws) | false | false | The AWS cloud provider configuration. |
| `azure` | [object](#providers-azure) | false | false | The Azure cloud provider configuration. |

### `recipeConfig` {#recipeconfig}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `bicep` | [object](#recipeconfig-bicep) | false | false | Configuration for Bicep Recipes. Controls how Bicep plans and applies templates as part of Recipe deployment. |
| `env` | object | false | false | Environment variables injected during recipe execution for the recipes in the environment, currently supported for Terraform recipes. |
| `envSecrets` | [object](#recipeconfig-envsecrets) | false | false | Environment variables containing sensitive information can be stored as secrets. The secrets are stored in Applications.Core/SecretStores resource. |
| `terraform` | [object](#recipeconfig-terraform) | false | false | Configuration for Terraform Recipes. Controls how Terraform plans and applies templates as part of Recipe deployment. |

### `recipes` {#recipes}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `templateKind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`bicep`](#recipes-bicep), [`terraform`](#recipes-terraform). |
| `parameters` | object | false | false | Key/value parameters to pass to the recipe template at deployment. |
| `templatePath` | string | true | false | Path to the template provided by the recipe. Currently only link to Azure Container Registry is supported. |

### `compute.identity` {#compute-identity}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | kind of identity setting<br />Allowed values: `azure.com.workload`, `systemAssigned`, `systemAssignedUserAssigned`, `undefined`, `userAssigned`. |
| `managedIdentity` | string array | false | false | The list of user assigned managed identities |
| `oidcIssuer` | string | false | false | The URI for your compute platform's OIDC issuer |
| `resource` | string | false | false | The resource ID of the provisioned identity |

### `compute.aci` {#compute-aci}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `resourceGroup` | string | false | false | The resource group to use for the environment. |

### `compute.kubernetes` {#compute-kubernetes}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `namespace` | string | true | false | The namespace to use for the environment. |

### `extensions.aci` {#extensions-aci}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `resourceGroup` | string | true | false | The resource group of the application environment. |

### `extensions.daprSidecar` {#extensions-daprsidecar}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `appId` | string | true | false | The Dapr appId. Specifies the identifier used by Dapr for service invocation. |
| `appPort` | integer | false | false | The Dapr appPort. Specifies the internal listening port for the application to handle requests from the Dapr sidecar. |
| `config` | string | false | false | Specifies the Dapr configuration to use for the resource. |
| `protocol` | string | false | false | Specifies the Dapr app-protocol to use for the resource.<br />Allowed values: `grpc`, `http`. |

### `extensions.kubernetesMetadata` {#extensions-kubernetesmetadata}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `annotations` | object | false | false | Annotations to be applied to the Kubernetes resources output by the resource |
| `labels` | object | false | false | Labels to be applied to the Kubernetes resources output by the resource |

### `extensions.kubernetesNamespace` {#extensions-kubernetesnamespace}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `namespace` | string | true | false | The namespace of the application environment. |

### `extensions.manualScaling` {#extensions-manualscaling}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `replicas` | integer | true | false | Replica count. |

### `providers.aws` {#providers-aws}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `scope` | string | true | false | Target scope for AWS resources to be deployed into. For example: '/planes/aws/aws/accounts/000000000000/regions/us-west-2'. |

### `providers.azure` {#providers-azure}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `scope` | string | true | false | Target scope for Azure resources to be deployed into. For example: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/testGroup'. |

### `recipeConfig.bicep` {#recipeconfig-bicep}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `authentication` | [object](#recipeconfig-bicep-authentication) | false | false | Authentication information used to access private bicep registries, which is a map of registry hostname to secret config that contains credential information. |

### `recipeConfig.envSecrets` {#recipeconfig-envsecrets}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `key` | string | true | false | The key for the secret in the secret store. |
| `source` | string | true | false | The ID of an Applications.Core/SecretStore resource containing sensitive data required for recipe execution. |

### `recipeConfig.terraform` {#recipeconfig-terraform}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `authentication` | [object](#recipeconfig-terraform-authentication) | false | false | Authentication information used to access private Terraform module sources. Supported module sources: Git. |
| `providers` | [object](#recipeconfig-terraform-providers) | false | false | Configuration for Terraform Recipe Providers. Controls how Terraform interacts with cloud providers, SaaS providers, and other APIs. For more information, please see: https://developer.hashicorp.com/terraform/language/providers/configuration. |

### `recipes.bicep` {#recipes-bicep}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `plainHttp` | boolean | false | false | Connect to the Bicep registry using HTTP (not-HTTPS). This should be used when the registry is known not to support HTTPS, for example in a locally-hosted registry. Defaults to false (use HTTPS/TLS). |

### `recipes.terraform` {#recipes-terraform}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `templateVersion` | string | false | false | Version of the template to deploy. For Terraform recipes using a module registry this is required, but must be omitted for other module sources. |

### `recipeConfig.bicep.authentication` {#recipeconfig-bicep-authentication}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `secret` | string | false | false | The ID of an Applications.Core/SecretStore resource containing credential information used to authenticate private container registry.The keys in the secretstore depends on the type. |

### `recipeConfig.terraform.authentication` {#recipeconfig-terraform-authentication}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `git` | [object](#recipeconfig-terraform-authentication-git) | false | false | Authentication information used to access private Terraform modules from Git repository sources. |

### `recipeConfig.terraform.providers` {#recipeconfig-terraform-providers}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `secrets` | [object](#recipeconfig-terraform-providers-secrets) | false | false | Sensitive data in provider configuration can be stored as secrets. The secrets are stored in Applications.Core/SecretStores resource. |

### `recipeConfig.terraform.authentication.git` {#recipeconfig-terraform-authentication-git}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `pat` | [object](#recipeconfig-terraform-authentication-git-pat) | false | false | Personal Access Token (PAT) configuration used to authenticate to Git platforms. |

### `recipeConfig.terraform.providers.secrets` {#recipeconfig-terraform-providers-secrets}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `key` | string | true | false | The key for the secret in the secret store. |
| `source` | string | true | false | The ID of an Applications.Core/SecretStore resource containing sensitive data required for recipe execution. |

### `recipeConfig.terraform.authentication.git.pat` {#recipeconfig-terraform-authentication-git-pat}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `secret` | string | false | false | The ID of an Applications.Core/SecretStore resource containing the Git platform personal access token (PAT). The secret store must have a secret named 'pat', containing the PAT value. A secret named 'username' is optional, containing the username associated with the pat. By default no username is specified. |
