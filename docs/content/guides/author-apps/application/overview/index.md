---
type: docs
title: "Overview: Radius applications"
linkTitle: "Overview"
description: "Learn about Radius applications and how they bring all of your services, dependencies, and relationships together."
weight: 100
categories: "Overview"
tags: ["applications"]
---

<img src="application.png" alt="Diagram of an application" width=350px >

A Radius application is the primary resource that brings all your "stuff" together. This can include services, dependencies, and relationships. Radius apps give you a single description and view into your entire application, and allow you to deploy and manage it easily.

## Simplify configuration and deployment with connections

Because Radius has all the relationships and requirements of an application, deployments and configurations are simplified. Developers no longer need to specify all the identity, networking, or other configuration that is normally required, and operators don't need to write custom deployment scripts.

For example, if you want a container to read from an Azure Storage Account without using Radius, this normally requires creating managed identities, RBAC roles, identity federation, Kubernetes service accounts, and more. With Radius, developers can define a single [connection]({{< ref "guides/author-apps/containers/overview#connections" >}}) from their container to a Storage Account, and Radius sets up all the required configuration automatically.

<img src="graph-automation.png" alt="A diagram showing a connection from a Radius container to an Azure storage account resulting in managed identities, role-based access control, and CSI drivers." width=600px >

## Customize your application with extensions

Extensions allow you to customize how resources are generated or customized as part of deployment.

### Kubernetes Namespace extension

The Kubernetes namespace extension allows you to customize how all of the resources within your application generate Kubernetes resources. See the [Kubernetes mapping guide]({{< ref kubernetes-mapping >}}) for more information on namespace mapping behavior.

### Kubernetes Metadata extension

The [Kubernetes Metadata extension]({{< ref "guides/operations/kubernetes/kubernetes-metadata">}}) enables you set and cascade Kubernetes metadata such as labels and Annotations on all the Kubernetes resources defined with in your Radius application.

## Query and understand your application with the Radius Application Graph

<img src="app-graph.png" alt="Diagram of the application graph" width=500px >

Radius applications are more than just client-side configuration and automation, they also provide a server-side graph of your application. This graph can be queried and used to understand your application, and can be used to power other Radius features and custom tooling. Refer to the [API concept docs]({{< ref "api-concept" >}}) and [Postman How-To guide]({{< ref "guides/operations/control-plane/howto-postman" >}}) for more information on how to query the application graph.

## Resource schema 

Refer to the [application schema docs]({{< ref application-schema >}}) for more information on how to define an application.

{{< button text="📄 Application schema" page="application-schema" >}}