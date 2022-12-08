---
type: docs
title: "Radius resource to Kubernetes object mapping"
linkTitle: "Resource mapping"
description: "Learn how Radius resources map to Kubernetes objects"
weight: 100
slug: "resource-mapping"
---

When deploying Radius resources to environments running on Kubernetes, the [control plane]({{< ref architecture >}}) will map these resources into one or more Kubernetes objects. This page describes these mappings and naming conventions.

<img src="kubernetes-mapping.png" alt="Diagram showing Radius resources being mapped to Kubernetes objects" width=600px />

## Namespace mapping

Radius environments allow you to specify the Kubernetes namespace where environment-scoped resources are generated. For example, if you set a Radius environment to use the namespace 'default' and deploy an environment-scoped Dapr Link, the backing dapr.io/Component will be deployed into the 'default' namespace.

Application-scoped resources are by default generated in a new Kubernetes namespace with the name format '<appName>-<envNamespace>'. For example, an application named 'myapp' with a container named 'frontend', deployed into the environment from above, will cause a Deployment named 'frontend' to be deployed into the namespace 'myapp-default'. This prevents multiple applications from conflicting with each other.

If you would like to override the default behavior and specify your own namespace for application resources to be generated into, you can leverage the kubernetesNamespace container extension. All application-scoped resources will be deployed into this namespace instead.

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
