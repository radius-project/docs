---
type: docs
title: "Container service"
linkTitle: "Container"
description: "Learn how to add a container to your Radius application"
weight: 300
---

`Container` provides an abstraction for a container workload that can be run on any platform Radius supports.

## Platform resources

Containers are hosted by Kubernetes as the container runtime today, regardless of which platform the application is deployed into. We plan to support additional container runtimes in the future.

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

Details on what to run and how to run it are defined in the `container` property:

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| image | y | The registry and image to download and run in your container. | `'myregistry/myimage:tag'`
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

The volumes mounted to the container, either local or external, are defined in the `volumes` section.
Learn more about volumes and supported resources in the [Volume docs]({{< ref volume >}}).

#### Readiness probe

Readiness probes detect when a container begins reporting it is ready to receive traffic, such as after loading a large configuration file that may take a couple seconds to process.
There are three types of probes available, `httpGet`, `tcp` and `exec`. For an `httpGet` probe, an HTTP GET request at the specified endpoint will be used to probe the application. If a success code is returned, the probe passes. If no code or an error code is returned, the probe fails, and the container won't receive any requests after a specified number of failures.
Any code greater than or equal to 200 and less than 400 indicates success. Any other code indicates failure.

For a `tcp` probe, the specified container port is probed to be listening. If not, the probe fails.

For an `exec` probe, a command is run within the container. A return code of 0 indicates a success and the probe succeeds. Any other return indicates a failure, and the container doesn't receive any requests after a specified number of failures.

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

Liveness probes detect when a container is in a broken state, restarting the container to return it to a healthy state.
There are three types of probes available, `httpGet`, `tcp` and `exec`. For an `httpGet` probe, an HTTP GET request at the specified endpoint will be used to probe the application. If a success code is returned, the probe passes. If no code or an error code is returned, the probe fails, and the container won't receive any requests after a specified number of failures.
Any code greater than or equal to 200 and less than 400 indicates success. Any other code indicates failure.

For a `tcp` probe, the specified container port is probed to be listening. If not, the probe fails.

For an `exec` probe, a command is run within the container. A return code of 0 indicates a success and the probe succeeds. Any other return indicates a failure, and the container doesn't receive any requests after a specified number of failures.

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

Connections define how a container connects to [other resources]({{< ref resource-schema >}}).

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
| kind | y | The type of resource you are connecting to. | `mongo.com/MongoDB`

Additional properties are available and required depending on the 'kind' of the extension.

## Sub-types
