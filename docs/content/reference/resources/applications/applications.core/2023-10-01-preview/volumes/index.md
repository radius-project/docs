---
type: docs
title: "Reference: applications.core/volumes@2023-10-01-preview"
linkTitle: "volumes"
description: "Detailed reference documentation for applications.core/volumes@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

Radius Volume resource.

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`azure.com.keyvault`](#azure-com-keyvault). |
| `application` | string | true | false | Fully qualified resource ID for the application |
| `environment` | string | false | false | Fully qualified resource ID for the environment that the application is linked to |
| `provisioningState` | string | false | true | The status of the asynchronous operation.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `status` | [object](#status) | false | true | Status of a resource. |

## Object Properties

### `status` {#status}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `compute` | [object](#status-compute) | false | false | The compute resource associated with the resource. |
| `outputResources` | [object](#status-outputresources)[] | false | false | Properties of an output resource |
| `recipe` | [object](#status-recipe) | false | true | The recipe data at the time of deployment |

### `azure.com.keyvault` {#azure-com-keyvault}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `certificates` | [object](#azure-com-keyvault-certificates) | false | false | The KeyVault certificates that this volume exposes |
| `keys` | [object](#azure-com-keyvault-keys) | false | false | The KeyVault keys that this volume exposes |
| `resource` | string | true | false | The ID of the keyvault to use for this volume resource |
| `secrets` | [object](#azure-com-keyvault-secrets) | false | false | The KeyVault secrets that this volume exposes |

### `status.compute` {#status-compute}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`aci`](#status-compute-aci), [`kubernetes`](#status-compute-kubernetes). |
| `identity` | [object](#status-compute-identity) | false | false | Configuration for supported external identity providers |
| `resourceId` | string | false | false | The resource id of the compute resource for application environment. |

### `status.outputResources` {#status-outputresources}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `id` | string | false | false | The UCP resource ID of the underlying resource. |
| `localId` | string | false | false | The logical identifier scoped to the owning Radius resource. This is only needed or used when a resource has a dependency relationship. LocalIDs do not have any particular format or meaning beyond being compared to determine dependency relationships. |
| `radiusManaged` | boolean | false | false | Determines whether Radius manages the lifecycle of the underlying resource. |

### `status.recipe` {#status-recipe}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `templateKind` | string | true | false | TemplateKind is the kind of the recipe template used by the portable resource upon deployment. |
| `templatePath` | string | true | false | TemplatePath is the path of the recipe consumed by the portable resource upon deployment. |
| `templateVersion` | string | false | false | TemplateVersion is the version number of the template. |

### `azure.com.keyvault.certificates` {#azure-com-keyvault-certificates}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `alias` | string | false | false | File name when written to disk |
| `certType` | string | false | false | Certificate object type to be downloaded - the certificate itself, private key or public key of the certificate<br />Allowed values: `certificate`, `privatekey`, `publickey`. |
| `encoding` | string | false | false | Encoding format. Default utf-8<br />Allowed values: `base64`, `hex`, `utf-8`. |
| `format` | string | false | false | Certificate format. Default pem<br />Allowed values: `pem`, `pfx`. |
| `name` | string | true | false | The name of the certificate |
| `version` | string | false | false | Certificate version |

### `azure.com.keyvault.keys` {#azure-com-keyvault-keys}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `alias` | string | false | false | File name when written to disk |
| `name` | string | true | false | The name of the key |
| `version` | string | false | false | Key version |

### `azure.com.keyvault.secrets` {#azure-com-keyvault-secrets}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `alias` | string | false | false | File name when written to disk |
| `encoding` | string | false | false | Encoding format. Default utf-8<br />Allowed values: `base64`, `hex`, `utf-8`. |
| `name` | string | true | false | The name of the secret |
| `version` | string | false | false | secret version |

### `status.compute.identity` {#status-compute-identity}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | kind of identity setting<br />Allowed values: `azure.com.workload`, `systemAssigned`, `systemAssignedUserAssigned`, `undefined`, `userAssigned`. |
| `managedIdentity` | string array | false | false | The list of user assigned managed identities |
| `oidcIssuer` | string | false | false | The URI for your compute platform's OIDC issuer |
| `resource` | string | false | false | The resource ID of the provisioned identity |

### `status.compute.aci` {#status-compute-aci}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `resourceGroup` | string | false | false | The resource group to use for the environment. |

### `status.compute.kubernetes` {#status-compute-kubernetes}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `namespace` | string | true | false | The namespace to use for the environment. |
