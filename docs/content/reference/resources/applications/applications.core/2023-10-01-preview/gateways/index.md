---
type: docs
title: "Reference: applications.core/gateways@2023-10-01-preview"
linkTitle: "gateways"
description: "Detailed reference documentation for applications.core/gateways@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

### Top-Level Resource

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **apiVersion** | '2023-10-01-preview' | The resource api version <br />_(ReadOnly, DeployTimeConstant)_ |
| **application** | string | Fully qualified resource ID for the application <br />_(ReadOnly)_ |
| **environment** | string | Fully qualified resource ID for the environment that the application is linked to <br />_(ReadOnly)_ |
| **hostname** | [GatewayHostname](#gatewayhostname) | Declare hostname information for the Gateway. Leaving the hostname empty auto-assigns one: mygateway.myapp.PUBLICHOSTNAMEORIP.nip.io. <br />_(ReadOnly)_ |
| **id** | string | The resource id <br />_(ReadOnly, DeployTimeConstant)_ |
| **internal** | bool | Sets Gateway to not be exposed externally (no public IP address associated). Defaults to false (exposed to internet). <br />_(ReadOnly)_ |
| **location** | string | The geo-location where the resource lives |
| **name** | string | The resource name <br />_(Required, DeployTimeConstant, Identifier)_ |
| **properties** | [GatewayProperties](#gatewayproperties) | The resource-specific properties for this resource. <br />_(Required)_ |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **routes** | [GatewayRoute](#gatewayroute)[] | Routes attached to this Gateway <br />_(ReadOnly)_ |
| **status** | [ResourceStatus](#resourcestatus) | Status of a resource. <br />_(ReadOnly)_ |
| **systemData** | [SystemData](#systemdata) | Azure Resource Manager metadata containing createdBy and modifiedBy information. <br />_(ReadOnly)_ |
| **tags** | [Record](#record) | Resource tags. |
| **tls** | [GatewayTls](#gatewaytls) | TLS configuration for the Gateway. <br />_(ReadOnly)_ |
| **type** | 'Applications.Core/gateways' | The resource type <br />_(ReadOnly, DeployTimeConstant)_ |
| **url** | string | URL of the gateway resource. Readonly <br />_(ReadOnly)_ |

### GatewayHostname

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **fullyQualifiedHostname** | string | Specify a fully-qualified domain name: myapp.mydomain.com. Mutually exclusive with 'prefix' and will take priority if both are defined. |
| **prefix** | string | Specify a prefix for the hostname: myhostname.myapp.PUBLICHOSTNAMEORIP.nip.io. Mutually exclusive with 'fullyQualifiedHostname' and will be overridden if both are defined. |

### GatewayProperties

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **application** | string | Fully qualified resource ID for the application <br />_(Required)_ |
| **environment** | string | Fully qualified resource ID for the environment that the application is linked to |
| **hostname** | [GatewayHostname](#gatewayhostname) | Declare hostname information for the Gateway. Leaving the hostname empty auto-assigns one: mygateway.myapp.PUBLICHOSTNAMEORIP.nip.io. |
| **internal** | bool | Sets Gateway to not be exposed externally (no public IP address associated). Defaults to false (exposed to internet). |
| **provisioningState** | 'Accepted' | 'Canceled' | 'Creating' | 'Deleting' | 'Failed' | 'Provisioning' | 'Succeeded' | 'Updating' | The status of the asynchronous operation. <br />_(ReadOnly)_ |
| **routes** | [GatewayRoute](#gatewayroute)[] | Routes attached to this Gateway <br />_(Required)_ |
| **status** | [ResourceStatus](#resourcestatus) | Status of a resource. <br />_(ReadOnly)_ |
| **tls** | [GatewayTls](#gatewaytls) | TLS configuration for the Gateway. |
| **url** | string | URL of the gateway resource. Readonly <br />_(ReadOnly)_ |

### GatewayRoute

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **destination** | string | The URL or id of the service to route to. Ex - 'http://myservice'. |
| **enableWebsockets** | bool | Enables websocket support for the route. Defaults to false. |
| **path** | string | The path to match the incoming request path on. Ex - /myservice. |
| **replacePrefix** | string | Optionally update the prefix when sending the request to the service. Ex - replacePrefix: '/' and path: '/myservice' will transform '/myservice/myroute' to '/myroute' |
| **timeoutPolicy** | [GatewayRouteTimeoutPolicy](#gatewayroutetimeoutpolicy) | The timeout policy for the route. |

### GatewayRouteTimeoutPolicy

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **backendRequest** | string | The backend request timeout in duration for the route. Cannot be greater than the request timeout. |
| **request** | string | The request timeout in duration for the route. Defaults to 15 seconds. |

### ResourceStatus

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **compute** | [EnvironmentCompute](#environmentcompute) | The compute resource associated with the resource. |
| **outputResources** | [OutputResource](#outputresource)[] | Properties of an output resource |
| **recipe** | [RecipeStatus](#recipestatus) | The recipe data at the time of deployment <br />_(ReadOnly)_ |

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

### OutputResource

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **id** | string | The UCP resource ID of the underlying resource. |
| **localId** | string | The logical identifier scoped to the owning Radius resource. This is only needed or used when a resource has a dependency relationship. LocalIDs do not have any particular format or meaning beyond being compared to determine dependency relationships. |
| **radiusManaged** | bool | Determines whether Radius manages the lifecycle of the underlying resource. |

### RecipeStatus

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **templateKind** | string | TemplateKind is the kind of the recipe template used by the portable resource upon deployment. <br />_(Required)_ |
| **templatePath** | string | TemplatePath is the path of the recipe consumed by the portable resource upon deployment. <br />_(Required)_ |
| **templateVersion** | string | TemplateVersion is the version number of the template. |

### GatewayTls

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| **certificateFrom** | string | The resource id for the secret containing the TLS certificate and key for the gateway. |
| **minimumProtocolVersion** | '1.2' | '1.3' | TLS minimum protocol version (defaults to 1.2). |
| **sslPassthrough** | bool | If true, gateway lets the https traffic sslPassthrough to the backend servers for decryption. |

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

