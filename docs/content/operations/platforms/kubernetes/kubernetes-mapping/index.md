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

## Resource mapping

The following resources map to Kubernetes objects:

| Radius resource                  | Kubernetes object | Name (application scoped) | Name (environment scoped) |
|----------------------------------|-------------------|---------------------------|---------------------------|
| [`Applications.Core/containers`]({{< ref container-schema >}}) | `apps/Deployment@v1` | `<application-name>-<resource-name>` | N/A |
| [`Applications.Core/httpRoutes`]({{< ref httproute >}})   | `core/Service@v1` | `<application-name>-<resource-name>` | N/A |
| [`Applications.Core/gateways`]({{< ref gateway >}})     | `projectcontour.io/HTTPProxy@v1` | `<application-name>-<resource-name>` |
| [`Applications.Link/daprPubSubBrokers`]({{< ref dapr-pubsub >}}) | `dapr.io/Component@v1alpha1` | `<application-name>-<resource-name>` | `<resource-name>` |
| [`Applications.Link/daprSecretStores`]({{< ref dapr-secretstore >}}) | `dapr.io/Component@v1alpha1` | `<application-name>-<resource-name>` | `<resource-name>` |
| [`Applications.Link/daprStateStores`]({{< ref dapr-statestore >}}) | `dapr.io/Component@v1alpha1` | `<application-name>-<resource-name>` | `<resource-name>` |
