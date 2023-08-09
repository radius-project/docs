---
type: docs
title: "DNS Service Discovery"
linkTitle: "DNS Service Discovery"
description: "Learn how to define HTTP communication between services with DNS Service Discovery"
weight: 400
---

## Consuming Container

{{< rad file="snippets/dns-connection.bicep" embed=true marker="//OUTBOUND" >}}

## Providing Container

{{< rad file="snippets/dns-connection.bicep" embed=true marker="//INBOUND" >}}

In this scenario, the frontend container is consuming a service provided by the backend container. The backend container is providing a service simply by exposing a `containerPort`. The frontend is connected to the backend via `DNS Service Discovery`.

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your container resource. Standard for container creation. | `'frontend'`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

### Properties

| Property | Description | Example |
|----------|-------------|-------------|
| application | The ID of the application resource this resource belongs to. | `app.id`
| [container](#container) | Container configuration. | [See below](#container)
| [connections](#connections) | List of connections to other resources. | [See below](#connections)

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
| port | n | Only needs to be set when a value different from containerPort is desired to be exposed. | `6544`
| scheme | n | Used to build URLs for DNS generation, defaults to `http` or `https` based on port value. | `http`

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

#### Volumes

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | A name key for the volume. | `tempstore`
| kind | y | The type of volume, either `ephemeral` or `persistent`. | `ephemeral`
| mountPath | y | The container path to mount the volume to. | `\tmp\mystore`
| managedStore | y* | The backing storage medium to use when kind is 'ephemeral'. Either `disk` or `memory`. | `memory`
| source | y* | A volume resource to mount when kind is 'persistent'. | `myvolume.id`
| rbac | n | The role-based access control level when kind is 'persistent'. Allowed values are `'read'` and `'write'`. Defaults to 'read'. | `'read'`

### Connections

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | A name key for the port. | `backend`
| source | y | The id (HttpRoute) or URL (DNS Service Discovery) of the link or resource the container is connecting to. | `db.id`, `'http://backend:3000'`
| [iam](#iam) | n | Identity and access management (IAM) roles to set on the target resource. | [See below](#iam)

#### IAM

Identity and access management (IAM) roles to set on the target resource.

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| kind | y | Type of IAM role. Only `azure` supported today | `'azure'`
| roles | y | The list IAM roles to set on the target resource. | `'Owner'`
