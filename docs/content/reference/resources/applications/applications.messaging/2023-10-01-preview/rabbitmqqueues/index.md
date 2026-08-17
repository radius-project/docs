---
type: docs
title: "Reference: applications.messaging/rabbitmqqueues@2023-10-01-preview"
linkTitle: "rabbitmqqueues"
description: "Detailed reference documentation for applications.messaging/rabbitmqqueues@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

RabbitMQQueue portable resource

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | false | false | Fully qualified resource ID for the application that the portable resource is consumed by (if applicable) |
| `environment` | string | true | false | Fully qualified resource ID for the environment that the portable resource is linked to |
| `host` | string | false | false | The hostname of the RabbitMQ instance |
| `port` | integer | false | false | The port of the RabbitMQ instance. Defaults to 5672 |
| `provisioningState` | string | false | true | The status of the asynchronous operation.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `queue` | string | false | false | The name of the queue |
| `recipe` | [object](#recipe) | false | false | The recipe used to automatically deploy underlying infrastructure for the resource |
| `resourceProvisioning` | string | false | false | Specifies how the underlying service/resource is provisioned and managed.<br />Allowed values: `manual`, `recipe`. |
| `resources` | [object](#resources)[] | false | false | List of the resource IDs that support the rabbitMQ resource |
| `secrets` | [object](#secrets) | false | false | The secrets to connect to the RabbitMQ instance |
| `status` | [object](#status) | false | true | Status of a resource. |
| `tls` | boolean | false | false | Specifies whether to use SSL when connecting to the RabbitMQ instance |
| `username` | string | false | false | The username to use when connecting to the RabbitMQ instance |
| `vHost` | string | false | false | The RabbitMQ virtual host (vHost) the client will connect to. Defaults to no vHost. |

## Object Properties

### `recipe` {#recipe}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `name` | string | true | false | The name of the recipe within the environment to use |
| `parameters` | object | false | false | Key/value parameters to pass into the recipe at deployment |

### `resources` {#resources}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `id` | string | true | false | Resource id of an existing resource |

### `secrets` {#secrets}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `password` | string | false | false | The password used to connect to the RabbitMQ instance |
| `uri` | string | false | false | The connection URI of the RabbitMQ instance. Generated automatically from host, port, SSL, username, password, and vhost. Can be overridden with a custom value |

### `status` {#status}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `compute` | [object](#status-compute) | false | false | The compute resource associated with the resource. |
| `outputResources` | [object](#status-outputresources)[] | false | false | Properties of an output resource |
| `recipe` | [object](#status-recipe) | false | true | The recipe data at the time of deployment |

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
