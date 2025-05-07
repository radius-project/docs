---
type: docs
title: "Overview: Radius Resource Types"
linkTitle: "Overview"
description: " Learn about the Radius Resource types"
weight: 100
---

Radius resource types define resources in the Radius Application. These are abstractions that provides a consistent interface for deploying and managing resources irrespective of the underlying platform or runtime. They are used to model the different components of your application, such as containers, gateways, databases, and queues. Each resource type has its own namespace, API versions, properties and other metadata that define how the resource behaves and interacts with other resources. Radius provides a set of built-in core resource types that cover common use cases, but you can also create your own custom resource types to meet your specific needs.

## Core Resource Types

The core resource types are the built-in resource types that are provided by Radius out of the box. They provide the basic functionality needed for your application. The core resource types include:

1. [Containers]({{< ref "/guides/resource-types/core-resource-types/containers" >}})
2. [Gateways]({{< ref "/guides/resource-types/core-resource-types/networking" >}})
3. [Secrets]({{< ref "/guides/resource-types/core-resource-types/secrets" >}})
4. [Dapr]({{< ref "/guides/resource-types/core-resource-types/dapr" >}})

You can use them as part of your applications or extend them with custom resource types. These resource types don't require a [Recipe]({{< ref "/guides/recipes/overview" >}}) to deploy the backing infrastructure and are deployed by Radius. They can also be embedded inside Recipes when defining composite resource types.<!-- insert how to composite resource -->

## Custom resource types

Custom resource types allow you to define and create your own resource types that are specific to your application. They provide a way to extend the functionality of Radius and create resources that are tailored to your specific needs. You can model your own resource type using the same principles as the core resource types, but you have the flexibility to define your own properties, API versions, and other metadata. More information on custom resource types can be found in the [Custom Resource Types guide]({{< ref "/guides/resource-types/custom-resource-types" >}}).

## Portable resource types

Portable resource types are sample resource types designed to be used across different cloud providers. They provide a consistent interface for managing resources, regardless of the underlying cloud provider. More information on portable resource types can be found in the [Portable Resource Types guide]({{< ref "/guides/resource-types/portable-resource-types" >}}).

## Other Resource Types

There are other resource types that are platform specific and can be used to manage resources on specific cloud providers or platforms. They are designed to work specifically with the respective provider APIs. These include

- [Kubernetes](<{{ ref "/guides/resource-types/kubernetes" >}})>) 
- [AWS](<{{ ref "/guides/resource-types/aws" >}}>)
- [Azure](<{{ ref "/guides/resource-types/azure" >}}>)
