---
type: docs
title: "Radius application"
linkTitle: "Application"
description: "Learn how to model your application and its services in Radius"
weight: 100
categories: "Overview"
tags: ["applications"]
---

## Overview

An [application]({{< ref application-graph>}}) is the primary resource that contains all of your services and relationships.

Because Radius has all the relationships and requirements of an application, deployments and configurations are simplified. Developers no longer need to specify all the identity, networking, or other configuration that is normally required, and operators don't need to write custom deployment scripts.

For example, if you want a container to read from an Azure Storage Account without using Radius, this normally requires creating managed identities, RBAC roles, identity federation, Kubernetes service accounts, and more. With Radius, developers can define a single [connection]({{< ref "container#connections" >}}) from their container to a Storage Account, and Radius sets up all the required configuration automatically.

<img src="graph-automation.png" alt="A diagram showing a connection from a Radius container to an Azure storage account resulting in managed identities, role-based access control, and CSI drivers." width=600px >

## Extensions

Extensions allow you to customize how resources are generated or customized as part of deployment.

### Kubernetes Namespace extension

The Kubernetes namespace extension allows you to customize how all of the resources within your application generate Kubernetes resources. See the [Kubernetes mapping guide]({{< ref kubernetes-mapping >}}) for more information on namespace mapping behavior

### Kubernetes Metadata extension

The [Kubernetes Metadata extension]({{< ref "/operations/platforms/kubernetes/kubernetes-metadata">}}) enables you set and cascade Kubernetes metadata such as labels and Annotations on all the Kubernetes resources defined with in your Radius application 

## Resource schema 

- [Application schema]({{< ref application-schema >}})

## Further reading

Refer to the [applications]({{< ref "/tags/applications" >}}) tag for more guides on the application resource.
