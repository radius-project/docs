---
type: docs
title: "Reference: applications.core/gateways@2023-10-01-preview"
linkTitle: "gateways"
description: "Detailed reference documentation for applications.core/gateways@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

Concrete tracked resource types can be created by aliasing this type using a specific property type.

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | true | false | Fully qualified resource ID for the application |
| `environment` | string | false | false | Fully qualified resource ID for the environment that the application is linked to |
| `hostname` | [object](#hostname) | false | false | Declare hostname information for the Gateway. Leaving the hostname empty auto-assigns one: mygateway.myapp.PUBLICHOSTNAMEORIP.nip.io. |
| `internal` | boolean | false | false | Sets Gateway to not be exposed externally (no public IP address associated). Defaults to false (exposed to internet). |
| `provisioningState` | string | false | true | The status of the asynchronous operation.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `routes` | [object](#routes)[] | true | false | Routes attached to this Gateway |
| `status` | [object](#status) | false | true | Status of a resource. |
| `tls` | [object](#tls) | false | false | TLS configuration for the Gateway. |
| `url` | string | false | true | URL of the gateway resource. Readonly |

## Object Properties

### `hostname` {#hostname}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `fullyQualifiedHostname` | string | false | false | Specify a fully-qualified domain name: myapp.mydomain.com. Mutually exclusive with 'prefix' and will take priority if both are defined. |
| `prefix` | string | false | false | Specify a prefix for the hostname: myhostname.myapp.PUBLICHOSTNAMEORIP.nip.io. Mutually exclusive with 'fullyQualifiedHostname' and will be overridden if both are defined. |

### `routes` {#routes}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `destination` | string | false | false | The URL or id of the service to route to. Ex - 'http://myservice'. |
| `enableWebsockets` | boolean | false | false | Enables websocket support for the route. Defaults to false. |
| `path` | string | false | false | The path to match the incoming request path on. Ex - /myservice. |
| `replacePrefix` | string | false | false | Optionally update the prefix when sending the request to the service. Ex - replacePrefix: '/' and path: '/myservice' will transform '/myservice/myroute' to '/myroute' |
| `timeoutPolicy` | [object](#routes-timeoutpolicy) | false | false | The timeout policy for the route. |

### `status` {#status}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `compute` | [object](#status-compute) | false | false | The compute resource associated with the resource. |
| `outputResources` | [object](#status-outputresources)[] | false | false | Properties of an output resource |
| `recipe` | [object](#status-recipe) | false | true | The recipe data at the time of deployment |

### `tls` {#tls}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `certificateFrom` | string | false | false | The resource id for the secret containing the TLS certificate and key for the gateway. |
| `minimumProtocolVersion` | string | false | false | TLS minimum protocol version (defaults to 1.2).<br />Allowed values: `1.2`, `1.3`. |
| `sslPassthrough` | boolean | false | false | If true, gateway lets the https traffic sslPassthrough to the backend servers for decryption. |

### `routes.timeoutPolicy` {#routes-timeoutpolicy}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `backendRequest` | string | false | false | The backend request timeout in duration for the route. Cannot be greater than the request timeout. |
| `request` | string | false | false | The request timeout in duration for the route. Defaults to 15 seconds. |

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
