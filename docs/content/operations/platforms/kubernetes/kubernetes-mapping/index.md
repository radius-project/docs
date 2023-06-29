---
type: docs
title: "Radius resource to Kubernetes object mapping"
linkTitle: "Resource mapping"
description: "Learn how Radius resources map to Kubernetes objects"
weight: 200
slug: "resource-mapping"
categories: "Concept"
tags: ["Kubernetes"]
---

When deploying resources such as a containers to environments running on Kubernetes, Radius will map these resources into one or more Kubernetes objects. This page describes these mappings and naming conventions.

<img src="kubernetes-mapping.png" alt="Diagram showing Radius resources being mapped to Kubernetes objects" width=600px />

## Namespace mapping

Application-scoped resources are by default generated in a new Kubernetes namespace with the name format `<envNamespace>-<appname>'`. This prevents multiple applications with resources of the same name from conflicting with each other.

For example, let's take an application named `'myapp'` with a container named `'frontend'`. This application is deployed into an environment configured with with the `'default'` namespace. A Kubernetes Deployment named `'frontend'` is now deployed into the namespace `'default-myapp'`.

If you wish to override the default behavior and specify your own namespace for application resources to be generated into, you can leverage the [`kubernetesNamespace` application extension]({{< ref "application-schema#kubernetesNamespace" >}}). All application-scoped resources will now be deployed into this namespace instead.

## Resource mapping

The following resources map to Kubernetes objects:

| Radius resource                  | Kubernetes object |
|----------------------------------|-------------------|
| [`Applications.Core/containers`]({{< ref container-schema >}}) | `apps/Deployment@v1` |
| [`Applications.Core/httpRoutes`]({{< ref httproute >}})   | `core/Service@v1` |
| [`Applications.Core/gateways`]({{< ref gateway >}})     | `projectcontour.io/HTTPProxy@v1` |
| [`Applications.Link/daprPubSubBrokers`]({{< ref dapr-pubsub >}}) | `dapr.io/Component@v1alpha1` |
| [`Applications.Link/daprSecretStores`]({{< ref dapr-secretstore >}}) | `dapr.io/Component@v1alpha1` |
| [`Applications.Link/daprStateStores`]({{< ref dapr-statestore >}}) | `dapr.io/Component@v1alpha1` |

## Resource naming

Resources that are generated in Kubernetes use the same name as the resource in Radius. For example, a Radius container named 'frontend' will map to a Kubernetes Deployment named 'frontend'. This makes it easy to conceptually map between Radius and Kubernetes resources.

For multiple Radius resources that map to a single Kubernetes resources (_i.e. daprPubSubBrokers, daprSecretStores, and daprStateStores all map to a dapr.io/Component_), when there are collisions in naming Radius has conflict logic to allow the first resource to be deployed, but throw a warning for subsequent resource deployments that have the same name. This prevents Radius resources unintentionally overwriting the same generated resource.
