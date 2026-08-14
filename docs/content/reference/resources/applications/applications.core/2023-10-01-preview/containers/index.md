---
type: docs
title: "Reference: applications.core/containers@2023-10-01-preview"
linkTitle: "containers"
description: "Detailed reference documentation for applications.core/containers@2023-10-01-preview"
---

{{< schemaExample >}}

## Schema

## Description

Concrete tracked resource types can be created by aliasing this type using a specific property type.

## Top-Level Properties

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `application` | string | true | false | Fully qualified resource ID for the application |
| `connections` | [object](#connections) | false | false | Specifies a connection to another resource. |
| `container` | [object](#container) | true | false | Definition of a container. |
| `environment` | string | false | false | Fully qualified resource ID for the environment that the application is linked to |
| `extensions` | [object](#extensions)[] | false | false | Extensions spec of the resource |
| `identity` | [object](#identity) | false | false | Configuration for supported external identity providers |
| `provisioningState` | string | false | true | The status of the asynchronous operation.<br />Allowed values: `Accepted`, `Canceled`, `Creating`, `Deleting`, `Failed`, `Provisioning`, `Succeeded`, `Updating`. |
| `resourceProvisioning` | string | false | false | Specifies how the underlying container resource is provisioned and managed.<br />Allowed values: `internal`, `manual`. |
| `resources` | [object](#resources)[] | false | false | A collection of references to resources associated with the container |
| `restartPolicy` | string | false | false | The restart policy for the underlying container<br />Allowed values: `Always`, `Never`, `OnFailure`. |
| `runtimes` | [object](#runtimes) | false | false | Specifies Runtime-specific functionality |
| `status` | [object](#status) | false | true | Status of a resource. |

## Object Properties

### `connections` {#connections}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `disableDefaultEnvVars` | boolean | false | false | default environment variable override |
| `iam` | [object](#connections-iam) | false | false | iam properties |
| `source` | string | true | false | The source of the connection |

### `container` {#container}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `args` | string array | false | false | Arguments to the entrypoint. Overrides the container image's CMD |
| `command` | string array | false | false | Entrypoint array. Overrides the container image's ENTRYPOINT |
| `env` | [object](#container-env) | false | false | environment |
| `image` | string | true | false | The registry and image to download and run in your container |
| `imagePullPolicy` | string | false | false | The pull policy for the container image<br />Allowed values: `Always`, `IfNotPresent`, `Never`. |
| `livenessProbe` | [object](#container-livenessprobe) | false | false | liveness probe properties |
| `ports` | [object](#container-ports) | false | false | container ports |
| `readinessProbe` | [object](#container-readinessprobe) | false | false | readiness probe properties |
| `volumes` | [object](#container-volumes) | false | false | container volumes |
| `workingDir` | string | false | false | Working directory for the container |

### `extensions` {#extensions}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`aci`](#extensions-aci), [`daprSidecar`](#extensions-daprsidecar), [`kubernetesMetadata`](#extensions-kubernetesmetadata), [`kubernetesNamespace`](#extensions-kubernetesnamespace), [`manualScaling`](#extensions-manualscaling). |

### `identity` {#identity}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | kind of identity setting<br />Allowed values: `azure.com.workload`, `systemAssigned`, `systemAssignedUserAssigned`, `undefined`, `userAssigned`. |
| `managedIdentity` | string array | false | false | The list of user assigned managed identities |
| `oidcIssuer` | string | false | false | The URI for your compute platform's OIDC issuer |
| `resource` | string | false | false | The resource ID of the provisioned identity |

### `resources` {#resources}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `id` | string | true | false | Resource id of an existing resource |

### `runtimes` {#runtimes}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `aci` | [object](#runtimes-aci) | false | false | The runtime configuration properties for ACI |
| `kubernetes` | [object](#runtimes-kubernetes) | false | false | The runtime configuration properties for Kubernetes |

### `status` {#status}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `compute` | [object](#status-compute) | false | false | The compute resource associated with the resource. |
| `outputResources` | [object](#status-outputresources)[] | false | false | Properties of an output resource |
| `recipe` | [object](#status-recipe) | false | true | The recipe data at the time of deployment |

### `connections.iam` {#connections-iam}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | The kind of IAM provider to configure<br />Allowed values: `azure`, `string`. |
| `roles` | string array | false | false | RBAC permissions to be assigned on the source resource |

### `container.env` {#container-env}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `value` | string | false | false | The value of the environment variable |
| `valueFrom` | [object](#container-env-valuefrom) | false | false | The reference to the variable |

### `container.livenessProbe` {#container-livenessprobe}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`exec`](#container-livenessprobe-exec), [`httpGet`](#container-livenessprobe-httpget), [`tcp`](#container-livenessprobe-tcp). |
| `failureThreshold` | integer | false | false | Threshold number of times the probe fails after which a failure would be reported |
| `initialDelaySeconds` | integer | false | false | Initial delay in seconds before probing for readiness/liveness |
| `periodSeconds` | integer | false | false | Interval for the readiness/liveness probe in seconds |
| `timeoutSeconds` | integer | false | false | Number of seconds after which the readiness/liveness probe times out. Defaults to 5 seconds |

### `container.ports` {#container-ports}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `containerPort` | integer | true | false | The listening port number |
| `port` | integer | false | false | Specifies the port that will be exposed by this container. Must be set when value different from containerPort is desired |
| `protocol` | string | false | false | Protocol in use by the port<br />Allowed values: `TCP`, `UDP`. |
| `scheme` | string | false | false | Specifies the URL scheme of the communication protocol. Consumers can use the scheme to construct a URL. The value defaults to 'http' or 'https' depending on the port value |

### `container.readinessProbe` {#container-readinessprobe}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`exec`](#container-readinessprobe-exec), [`httpGet`](#container-readinessprobe-httpget), [`tcp`](#container-readinessprobe-tcp). |
| `failureThreshold` | integer | false | false | Threshold number of times the probe fails after which a failure would be reported |
| `initialDelaySeconds` | integer | false | false | Initial delay in seconds before probing for readiness/liveness |
| `periodSeconds` | integer | false | false | Interval for the readiness/liveness probe in seconds |
| `timeoutSeconds` | integer | false | false | Number of seconds after which the readiness/liveness probe times out. Defaults to 5 seconds |

### `container.volumes` {#container-volumes}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `kind` | string | true | false | Discriminator property that selects the variant. Allowed values: [`ephemeral`](#container-volumes-ephemeral), [`persistent`](#container-volumes-persistent). |
| `mountPath` | string | false | false | The path where the volume is mounted |

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

### `runtimes.aci` {#runtimes-aci}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `gatewayID` | string | false | false | The ID of the gateway that is providing L7 traffic for the container |

### `runtimes.kubernetes` {#runtimes-kubernetes}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `base` | string | false | false | The serialized YAML manifest which represents the base Kubernetes resources to deploy, such as Deployment, Service, ServiceAccount, Secrets, and ConfigMaps. |
| `pod` | object | false | false | A strategic merge patch that will be applied to the PodSpec object when this container is being deployed. |

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

### `container.env.valueFrom` {#container-env-valuefrom}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `secretRef` | [object](#container-env-valuefrom-secretref) | true | false | The secret reference |

### `container.livenessProbe.exec` {#container-livenessprobe-exec}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `command` | string | true | false | Command to execute to probe readiness/liveness |

### `container.livenessProbe.httpGet` {#container-livenessprobe-httpget}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `containerPort` | integer | true | false | The listening port number |
| `headers` | object | false | false | Custom HTTP headers to add to the get request |
| `path` | string | true | false | The route to make the HTTP request on |

### `container.livenessProbe.tcp` {#container-livenessprobe-tcp}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `containerPort` | integer | true | false | The listening port number |

### `container.readinessProbe.exec` {#container-readinessprobe-exec}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `command` | string | true | false | Command to execute to probe readiness/liveness |

### `container.readinessProbe.httpGet` {#container-readinessprobe-httpget}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `containerPort` | integer | true | false | The listening port number |
| `headers` | object | false | false | Custom HTTP headers to add to the get request |
| `path` | string | true | false | The route to make the HTTP request on |

### `container.readinessProbe.tcp` {#container-readinessprobe-tcp}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `containerPort` | integer | true | false | The listening port number |

### `container.volumes.ephemeral` {#container-volumes-ephemeral}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `managedStore` | string | true | false | Backing store for the ephemeral volume<br />Allowed values: `disk`, `memory`. |

### `container.volumes.persistent` {#container-volumes-persistent}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `permission` | string | false | false | Container read/write access to the volume<br />Allowed values: `read`, `write`. |
| `source` | string | true | false | The source of the volume |

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

### `container.env.valueFrom.secretRef` {#container-env-valuefrom-secretref}

| Property | Type | Required | Read-Only | Description |
|----------|------|----------|-----------|-------------|
| `key` | string | true | false | The key for the secret in the secret store. |
| `source` | string | true | false | The ID of an Applications.Core/SecretStore resource containing sensitive data required for recipe execution. |
