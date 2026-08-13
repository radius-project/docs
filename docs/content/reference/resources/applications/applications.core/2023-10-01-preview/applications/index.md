---
type: docs
title: "Reference: applications.core/applications@2023-10-01-preview"
linkTitle: "applications"
description: "Detailed reference documentation for applications.core/applications@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

Radius Application resource

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `environment` | string | true | false | Fully qualified resource ID for the environment that the application is linked to |
| `extensions` | [object](#extensions)[] | false | false | The application extension. |
| `provisioningState` | string | false | true | The status of the asynchronous operation.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `status` | [object](#status) | false | true | Status of a resource. |

## Object Properties

### `extensions` {#extensions}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`aci`](#extensions-aci), [`daprSidecar`](#extensions-daprsidecar), [`kubernetesMetadata`](#extensions-kubernetesmetadata), [`kubernetesNamespace`](#extensions-kubernetesnamespace), [`manualScaling`](#extensions-manualscaling). |

### `status` {#status}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `compute` | [object](#status-compute) | false | false | The compute resource associated with the resource. |
| `outputResources` | [object](#status-outputresources)[] | false | false | Properties of an output resource |
| `recipe` | [object](#status-recipe) | false | true | The recipe data at the time of deployment |

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
