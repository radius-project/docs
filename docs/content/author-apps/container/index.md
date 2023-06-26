---
type: docs
title: "Containerized workloads"
linkTitle: "Containers"
description: "Model and run container workloads in your Radius application"
weight: 300
categories: "Overview"
tags: ["containers"]
---

## Overview

A Radius container provides the abstraction to model and run your container workloads in your Radius application. 

{{< rad file="snippets/container.bicep" embed=true marker="//CONTAINER" >}}

## Supported runtimes

Containers are run on the same Kubernetes cluster as your [Radius installation]({{< ref platforms >}}). We plan to support additional container runtimes and configurations in the future

## Capabilities

Radius containers enables you to specify the image for the container, the ports the container provides and consumes, the environment variables to set, the volumes to mount, and the probes to run.

Additionally you can customize the behavior of the containers with the help of [extensions](#extensions).
### Image

The image for your container workload to pull and run. If you want to pull the container image from a private container register, you need to allow access from your Kubernetes cluster. Follow the documentation to [configure private container registries access]({{< ref "/operations/platforms/kubernetes/supported-clusters#configure-container-registry-access" >}}).

### Ports

Ports allow you to expose your container to incoming network traffic. Refer to the [networking guide]({{< ref networking >}}) for more information on container networking.

### Volumes

The volumes mounted to the container, either ephemeral or persistent, are defined in the volumes section.

Ephemeral volumes have the same lifecycle as the container, being deployed and deleted with the container. They create an empty directory on the host and mount it to the container.

Persistent volumes have life cycles that are separate from the container. Containers can mount these persistent volumes and restart without losing data. Persistent volumes can also be useful for storing data that needs to be accessed by multiple containers.

### Probes

#### Readiness Probe

Readiness probes detect when a container begins reporting it is ready to receive traffic, such as after loading a large configuration file that may take a couple seconds to process. There are three types of probes available, httpGet, tcp and exec. 

For an **httpGet** probe, an HTTP GET request at the specified endpoint will be used to probe the application. If a success code is returned, the probe passes. If no code or an error code is returned, the probe fails, and the container won’t receive any requests after a specified number of failures. Any code greater than or equal to 200 and less than 400 indicates success. Any other code indicates failure.

For a **tcp** probe, the specified container port is probed to be listening. If not, the probe fails.

For an **exec probe**, a command is run within the container. A return code of 0 indicates a success and the probe succeeds. Any other return indicates a failure, and the container doesn’t receive any requests after a specified number of failures

Refer to the readiness probes section of the [container resource schema]({{< ref "container-schema#readiness-probes" >}}) for more details.

#### Liveness Probe

Liveness probes detect when a container is in a broken state, restarting the container to return it to a healthy state. There are three types of probes available, httpGet, tcp and exec.

For an **httpGet probe**, an HTTP GET request at the specified endpoint will be used to probe the application. If a success code is returned, the probe passes. If no code or an error code is returned, the probe fails, and the container won’t receive any requests after a specified number of failures. Any code greater than or equal to 200 and less than 400 indicates success. Any other code indicates failure.

For a **tcp probe**, the specified container port is probed to be listening. If not, the probe fails.

For an **exec probe**, a command is run within the container. A return code of 0 indicates a success and the probe succeeds. Any other return indicates a failure, and the container doesn’t receive any requests after a specified number of failures.

Refer to the probes section of the [container resource schema]({{< ref "container-schema#liveness-probes" >}}) for more details.

### Connections

Connections enable communication between your container and other resources, such as databases, message queues, and other services. A connection injects information about the resource you connect to as environment variables. This could be connection strings, access keys, password or other information needed for communication between the container and the resource it connects to. It also enables you to configure the RBAC permissions for the container to access the resource.

Refer to the [connections schema] for containers({{< ref "container-schema#connections" >}}) for more details.

### Extensions

Extensions define additional capabilities and configuration for a container.

#### Kubernetes metadata extension

The [Kubernetes metadata extension]({{< ref kubernetes-metadata>}}) enables you to configure the Kubernetes metadata for the container. This includes the labels and annotations for the container. Refer to to the extension overview page to get more details about the extension and how it works with other Radius resources.

#### Manual scaling extension

The manualScaling extension configures the number of replicas of a compute instance (such as a container) to run. Refer to the [container resource schema]({{< ref "container-schema#extensions" >}}) for more details.

#### Dapr sidecar extension

The `daprSidecar` extensions adds and configures a [Dapr](https://dapr.io) sidecar to your application. Refer to the [container resource schema]({{< ref "container-schema#extensions" >}}) for more details

## Resource schema 

- [Container schema]({{< ref container-schema >}})

## Further reading

{{< categorizeby category="Quickstart" tag="containers" >}}
{{< categorizeby category="How-To" tag="containers" >}}
