---
type: docs
title: "Reference: applications.core/secretstores@2023-10-01-preview"
linkTitle: "secretstores"
description: "Detailed reference documentation for applications.core/secretstores@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

Concrete tracked resource types can be created by aliasing this type using a specific property type.

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | false | false | Fully qualified resource ID for the application |
| `data` | [object](#data) | true | false | An object to represent key-value type secrets |
| `environment` | string | false | false | Fully qualified resource ID for the environment that the application is linked to |
| `provisioningState` | string | false | true | The status of the asynchronous operation.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `resource` | string | false | false | The resource id of external secret store. |
| `status` | [object](#status) | false | true | Status of a resource. |
| `type` | string | false | false | The type of secret store data<br />Allowed values: `awsIRSA`, `azureWorkloadIdentity`, `basicAuthentication`, `certificate`, `generic`. |

## Object Properties

### `data` {#data}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `encoding` | string | false | false | The encoding of value<br />Allowed values: `base64`, `raw`. |
| `value` | string | false | false | The value of secret. |
| `valueFrom` | [object](#data-valuefrom) | false | false | The referenced secret in properties.resource |

### `status` {#status}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `compute` | [object](#status-compute) | false | false | The compute resource associated with the resource. |
| `outputResources` | [object](#status-outputresources)[] | false | false | Properties of an output resource |
| `recipe` | [object](#status-recipe) | false | true | The recipe data at the time of deployment |

### `data.valueFrom` {#data-valuefrom}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `name` | string | true | false | The name of the referenced secret. |
| `version` | string | false | false | The version of the referenced secret. |

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
