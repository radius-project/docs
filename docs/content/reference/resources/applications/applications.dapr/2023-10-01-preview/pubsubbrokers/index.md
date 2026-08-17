---
type: docs
title: "Reference: applications.dapr/pubsubbrokers@2023-10-01-preview"
linkTitle: "pubsubbrokers"
description: "Detailed reference documentation for applications.dapr/pubsubbrokers@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

Dapr PubSubBroker portable resource

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | false | false | Fully qualified resource ID for the application that the portable resource is consumed by (if applicable) |
| `auth` | [object](#auth) | false | false | The name of the Dapr component to be used as a secret store |
| `componentName` | string | false | true | The name of the Dapr component object. Use this value in your code when interacting with the Dapr client to use the Dapr component. |
| `environment` | string | true | false | Fully qualified resource ID for the environment that the portable resource is linked to |
| `metadata` | [object](#metadata) | false | false | The metadata for Dapr resource which must match the values specified in Dapr component spec |
| `provisioningState` | string | false | true | The status of the asynchronous operation.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `recipe` | [object](#recipe) | false | false | The recipe used to automatically deploy underlying infrastructure for the resource |
| `resourceProvisioning` | string | false | false | Specifies how the underlying service/resource is provisioned and managed.<br />Allowed values: `manual`, `recipe`. |
| `resources` | [object](#resources)[] | false | false | A collection of references to resources associated with the pubSubBroker |
| `status` | [object](#status) | false | true | Status of a resource. |
| `type` | string | false | false | Dapr component type which must matches the format used by Dapr Kubernetes configuration format |
| `version` | string | false | false | Dapr component version |

## Object Properties

### `auth` {#auth}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `secretStore` | string | false | false | Secret store to fetch secrets from |

### `metadata` {#metadata}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `secretKeyRef` | [object](#metadata-secretkeyref) | false | false | A reference of a value in a secret store component |
| `value` | string | false | false | The plain text value of the metadata |

### `recipe` {#recipe}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `name` | string | true | false | The name of the recipe within the environment to use |
| `parameters` | object | false | false | Key/value parameters to pass into the recipe at deployment |

### `resources` {#resources}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `id` | string | true | false | Resource id of an existing resource |

### `status` {#status}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `compute` | [object](#status-compute) | false | false | The compute resource associated with the resource. |
| `outputResources` | [object](#status-outputresources)[] | false | false | Properties of an output resource |
| `recipe` | [object](#status-recipe) | false | true | The recipe data at the time of deployment |

### `metadata.secretKeyRef` {#metadata-secretkeyref}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `key` | string | true | false | The field to select in the secret value. If the secret value is a string, it should be equal to the secret name |
| `name` | string | true | false | Secret name in the secret store component |

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
