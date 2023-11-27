---
type: docs
title: Radius architecture
linkTitle: Architecture
description: Learn about the architecture of the Radius API and services
weight: 600
categories: "Concept"
tags: ["control plane"]
slug: 'architecture'
---

## Overview

Radius provides an HTTP-based API and supporting tools that can deploy and manage cloud-native applications as well as on-premises or cloud resources. The server-side API components are also sometimes called a control-plane. The Radius API can be hosted inside a Kubernetes cluster or as a standalone set of processes or containers. Tools that are used with Radius (like the `rad` CLI) communicate with the API.

This page serves as documentation about the overall architecture of Radius to help educate contributors to the project or any user who wants a deeper understanding of the system and its capabilities.

**Prerequisite:** Read the [API docs]({{< ref api-concept >}}) to understand the terminology and structure of the Radius API.

## Design motivations for Radius

The design of the Radius API is based on the team's collected experience building and running hyper-scale cloud resource-management systems. Radius uses proven designs that provide extensibility, multi-tenancy, reliability, and scalability at the level of the world's largest clouds. While Radius used with Kubernetes, the core of Radius is intentionally decoupled from Kubernetes so that Radius can be hosted in any scenario and at any scale.

## Understanding the overall architecture

The overall architecture of Radius has three parts:

- A general resource management API.
- Resource providers for cloud-native applications.
- Tools (`rad` CLI, Bicep) for deploying and managing applications using the API.

This section will provide a summary of each of these components, as well as examples how common workflows fit together.

{{% alert title="🚧🚧🚧 Under construction 🚧🚧🚧" color="info" %}}
We're working on adding a diagram to illustrate these points.
{{% /alert %}}

### UCP: a general resource management API

The Radius API uses a centralized hub-and-spoke architecture. This API provides a single entry-point for authentication, authorization, routing, and other quality-of-service or correctness concerns. All HTTP traffic into the Radius API comes through this central point so that it can be validated before being routed to the appropriate resource provider microservice. 

The service that performs this central functionality in Radius is called the Universal Control-Plane (UCP). UCP receives all inbound HTTP traffic to the Radius API and either serves the response itself or routes the request to a resource provider. UCP is also the central point for extensibility; each resource provider is registered centrally so that UCP knows where to send requests for that resource type.

UCP contains functionality for federating with separate resource managers as well as its resource providers. For example UCP can route requests to Azure or AWS to manage resources on those cloud systems. 

UCP is a scalable REST API that can function either with a single global shard or using regional sharding. UCP is based on the design principles of the Azure Resource Manager (ARM) control-plane but generalizes to work across multiple clouds and systems. The UCP codebase is fully open-source and was created from scratch as part of the Radius project. UCP is written in Go.

UCP provides routing and federation with internal and external services:

- The management of resources built-in to Radius (such as `Applications.Core/containers`) is delegated to the appropriate resource provider.
- The management of cloud resources external to Radius (such as an AWS S3 Bucket, or Azure CosmosDB database) is federated to an external cloud-provider API.

### Resource providers built into Radius

The role of resource provider in the overall system is to perform the CRUDL+ operations associated with a one or more resource types. Resource providers only accept traffic from UCP and so can assume that any requests they receive are authorized. Each resource provider and the set of resource types it handles must be registered with UCP.

Like UCP, each resource provider is a scalable REST API that can be deployed as a single global shard or sharded by region.

Radius provides the following resource providers in the default installation:

- **Applications.Core**: _Core_ resources of an application, including the application itself, containers, gateways, and routes.
- **Applications.Dapr**: Integration with the [Dapr](https://dapr.io/) programming model. Supports management of Dapr building-blocks and configuration.
- **Applications.Datastores**: Abstractions for data-stores that can be used within an application.
- **Applications.Messaging**: Abstractions for messaging systems that can be used within an application.
- **Bicep.Deployments**: Functionality for processing Bicep deployments.

#### Applications Resource Provider

The **Applications.*** resource providers implement the bulk of Radius' user-facing functionality, including:

- Creating and managing platform resources used to run an application (_eg: Kubernetes Deployments and Services_).
- Responding to queries from the CLI (_eg: list all applications, show configuration of a container_).
- Storing and retrieving dependency information like connection-strings, hostnames, and passwords.
- Executing recipes to create cloud infrastructure.

All of Radius' core concepts are expressed using resources:

- Applications
- Environments
- Containers
- Dependency resources (eg: Mongo Database, Dapr State Store)

All of these resources can be manipulated using the CRUDL+ operations that the resource providers provide. Since the functionality is implemented as part of the API any number of tools can have access to this functionality.

The `Applications.*` resource providers are fully-open source and were created as part of the Radius project. The `Applications.Core` and `Applications.*` resource providers are written in Go.

#### Bicep Deployments Resource Provider

The **Bicep.Deployments** resource provider implements the functionality for handling Bicep deployments.

First a Bicep file is compiled to an intermediate representation called ARM-JSON and then the compiled payload is sent to the server to create a `Bicep.Deployments/deployments` resource. The deployments resource provider processes the ARM-JSON template to create or update other resources by making HTTP requests to UCP. After the processing is completed, the `Bicep.Deployments/deployments` resource is retained for informational purposes. 

{{% alert title="🚧🚧🚧 Under construction 🚧🚧🚧" color="info" %}}
The `Bicep.Deployments` resource provider shares some components with the Azure service for processing Bicep and ARM-JSON deployments. The codebase will be fully open-sourced and ownership will be split between the Bicep team and the Radius project. The `Bicep.Deployments` resource provider is written in C#.
{{% /alert %}}

### Tools (rad CLI, Bicep)

Tools that work with Radius do so though the API. The CRUDL+ operations provided by resource providers are orchestrated by tools to perform tasks like application deployment, or listing cloud resources in use by an application.

This section will provide an overview of how various tools interact with the Radius APIs.

#### rad CLI

The bulk of rad CLI functionality can be described as *management functions* that are serviced using the Read and List operations of the Radius API. A typical interaction like listing applications that have been created will only require one request to the API.

#### Bicep

Resources (_Radius, Azure, AWS, Kubernetes_) can be expressed declaratively within a Bicep file and deployed via `rad deploy`

The functionality of `rad deploy` to deploy a Bicep file also uses the Radius API. Once the deployment has been sent to the server, the CLI monitors the `Bicep.Deployments/deployments` resource to display progress information to the user.

#### Terraform

{{% alert title="🚧🚧🚧 Under construction 🚧🚧🚧" color="info" %}}
We have not yet published a Terraform provider for Radius. This section describes the architecture differences to help explain the architecture differences.
{{% /alert %}}

Processing of Terraform deployments takes place on the client that initiated the operation. The Radius Terraform provider makes requests through the API to Read or Create/Update resources as needed.

In contrast, processing of Bicep templates takes place on the server-side inside a resource provider. The tasks done by Terraform and Bicep are very similar but each tool has a different architecture. 

#### Example tasks and data flows

This section describes example tasks that can be performed with Radius and how the data flows through the overall system.

{{< tabs "List applications" "Deploy Bicep file" "Deploy Terraform file">}}

{{% codetab %}}
When listing applications using the `rad` CLI:

1. The client sends an HTTP request to the Radius API requesting the list of applications.
1. UCP receives the request for the `Applications.Core/applications` List operation and looks up the internal address for the `Applications.Core` resource provider.
1. UCP proxies the HTTP request to the `Applications.Core` resource provider.
1. The `Applications.Core` resource provider handles the request and responds with the list of applications.

{{< image src="flow-list-apps.png" alt="Diagram of the API flow described above" width="1000px" >}}

{{% /codetab %}}

{{% codetab %}}
When using Bicep to author and deploy Radius Applications:

1. The client compiles the Bicep file to an ARM-JSON template and submits a request for processing as a `Bicep.Deployments/deployments` resource.
1. UCP receives the request for the `Bicep.Deployments/deployments` Create operation and looks up the internal address for the `Bicep.Deployments` resource provider.
1. UCP proxies the HTTP request to the `Bicep.Deployments` resource provider.
1. The `Bicep.Deployments` resource provider processes the ARM-JSON template. For each resource in the template:
  a. The `Bicep.Deployments` resource provider makes a request to UCP to Create/Update the resource.
  b. UCP routes the request to the appropriate resource provider to be handled.

{{< image src="flow-deploy.png" alt="Diagram of the API flow described above" width="1000px" >}}

{{% /codetab %}}

{{% codetab %}}
When using the `tf` CLI to deploy a Radius Application using Terraform:

1. Terraform reads the configuration, loads credentials, parses the file, and instantiates its providers. For each resource in the file:
  a. Terraform asks the appropriate provider to Create or Update the resource. 
  b. In the case of a non-Radius resource, (eg: AWS S3 Bucket) the Terraform provider processes the resource without involving the Radius API.
  c. In the case of a Radius resource the Terraform provider makes a request the Radius API to Create/Update a resource.
  d. UCP routes the request to the appropriate resource provider to be handled.

{{< image src="flow-terraform.png" alt="Diagram of the API flow described above" width="1000px" >}}

{{% /codetab %}}

{{< /tabs >}}

## Next step

Now that you have an understanding of the Radius architecture, try Radius out:

{{< button text="Get started" page="getting-started" size="btn-lg" color="success" >}}

