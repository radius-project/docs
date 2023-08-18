---
type: docs
title: "Container service"
linkTitle: "Container"
description: "Learn how to add a container to your Radius application"
weight: 300
---

`Container` provides an abstraction for a container workload that can be run on any platform Radius supports.

## Resource format

{{< rad file="snippets/container.bicep" embed=true marker="//CONTAINER" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `frontend`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| application | y | The ID of the application resource this container belongs to. | `app.id`
| [container](#container) | y | Container configuration. | [See below](#container)
| [connections](#connections) | n | List of connections to other resources. | [See below](#connections)
| [extensions](#extensions) | n | List of extensions on the container. | [See below](#extensions)

### Container

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| image | y | The registry and image to download and run in your container. Follows the format `<registry-hostname>:<port>/<image-name>:<tag>` where registry hostname is optional and defaults to the Docker public registry, port is optional and defaults to 443, tag is optional and defaults to `latest`.| `myregistry.azurecr.io/myimage:latest`
| env | n | A list of environment variables to be set for the container. | `'ENV_VAR': 'value'`
| command | n | Entrypoint array. Overrides the container image's ENTRYPOINT. | `['/bin/sh']`
| args | n | Arguments to the entrypoint. Overrides the container image's CMD. | `['-c', 'while true; do echo hello; sleep 10;done']`
| workingDir | n | Working directory for the container. | `'/app'`
| [ports](#ports) | n | Ports the container provides | [See below](#ports).
| [readinessProbe](#readiness-probe) | n | Readiness probe configuration. | [See below](#readiness-probe).
| [livenessProbe](#liveness-probe) | n | Liveness probe configuration. | [See below](#liveness-probe).
| [volumes](#volumes) | n | Volumes to mount into the container. | [See below](#volumes).

#### Ports

The ports offered by the container are  defined in the `ports` section.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | A name key for the port. | `http`
| containerPort | y | The port the container exposes. | `80`
| protocol | n | The protocol the container exposes. Options are 'TCP' and 'UCP'. | `'TCP'`
| provides | n | The id of the [Route]({{< ref networking >}}) the container provides. | `http.id`

#### Volumes

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | A name key for the volume. | `tempstore`
| kind | y | The type of volume, either `ephemeral` or `persistent`. | `ephemeral`
| mountPath | y | The container path to mount the volume to. | `\tmp\mystore`
| managedStore | y* | The backing storage medium to use when kind is 'ephemeral'. Either `disk` or `memory`. | `memory`
| source | y* | A volume resource to mount when kind is 'persistent'. | `myvolume.id`
| rbac | n | The role-based access control level when kind is 'persistent'. Allowed values are `'read'` and `'write'`. Defaults to 'read'. | `'read'`

#### Readiness probe

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | Type of readiness check, `httpGet` or `tcp` or `exec`. | `httpGet`
| containerPort | n | Used when kind is `httpGet` or `tcp`. The listening port number. | `8080`
| path | n | Used when kind is `httpGet`. The route to make the HTTP request on | `'/healthz'`
| command | n | Used when kind is `exec`. Command to execute to probe readiness | `'/healthz'`
| initialDelaySeconds | n | Initial delay in seconds before probing for readiness. | `10`
| failureThreshold | n | Threshold number of times the probe fails after which a failure would be reported. | `5`
| periodSeconds | n | Interval for the readiness probe in seconds. | `5`

#### Liveness probe

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | Type of liveness check, `httpGet` or `tcp` or `exec`. | `httpGet`
| containerPort | n | Used when kind is `httpGet` or `tcp`. The listening port number. | `8080`
| path | n | Used when kind is `httpGet`. The route to make the HTTP request on | `'/healthz'`
| command | n | Used when kind is `exec`. Command to execute to probe liveness | `'/healthz'`
| initialDelaySeconds | n | Initial delay in seconds before probing for liveness. | `10`
| failureThreshold | n | Threshold number of times the probe fails after which a failure would be reported. | `5`
| periodSeconds | n | Interval for the liveness probe in seconds. | `5`

### Connections

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | A name key for the port. | `inventory`
| source | y | The id of the link or resource the container is connecting to. | `db.id`
| [iam](#iam) | n | Identity and access management (IAM) roles to set on the target resource. | [See below](#iam)

#### IAM

Identity and access management (IAM) roles to set on the target resource.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | Type of IAM role. Only `azure` supported today | `'azure'`
| roles | y | The list IAM roles to set on the target resource. | `'Owner'`

### Extensions

Extensions define additional capabilities and configuration for a container.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of extension being used. | `kubernetesMetadataextension`

Additional properties are available and required depending on the 'kind' of the extension.

#### kubernetesMetadata

The [Kubernetes Metadata extension]({{< ref "/operations/kubernetes/kubernetes-metadata">}}) enables you set and cascade Kubernetes metadata such as labels and Annotations on all the Kubernetes resources defined with in your Radius application. For examples refer to the extension overview page.

##### Properties

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | The kind of extension being used. Must be 'kubernetesMetadata' | `kubernetesMetadata` |
| [labels](#labels)| n | The Kubernetes labels to be set on the application and its resources | [See below](#labels)|
| [annotations](#annotations) | n | The Kubernetes annotations to set on your application and its resources  | [See below](#annotations)|

###### labels

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| user defined label key | y | The key and value of the label to be set on the application and its resources.|`'team.name': 'frontend'`

###### annotations

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| user defined annotation key | y | The key and value of the annotation to be set on the application and its resources.| `'app.io/port': '8081'` |

#### daprSidecar

The `daprSidecar` extensions adds and configures a [Dapr](https://dapr.io) sidecar to your application.

##### Properties

| Property | Required | Description | Example |
|----------|:--------:|-------------|---------|
| kind | y | The kind of extension. | `daprSidecar`
| appId | n | The appId of the Dapr sidecar. | `backend` |
| appPort | n | The port your service exposes to Dapr | `3500`
| config | n | The configuration to use for the Dapr sidecar |

#### manualScaling

The `manualScaling` extension configures the number of replicas of a compute instance (such as a container) to run.

##### Properties

| Property | Required | Description | Example |
|----------|:--------:|-------------|---------|
| kind | y | The kind of extension. | `manualScaling`
| replicas | Y | The number of replicas to run | `5` |

