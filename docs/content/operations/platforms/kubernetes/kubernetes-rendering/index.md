---
type: docs
title: "Rendering Radius resources on Kubernetes"
linkTitle: "Rendering"
description: "Learn how Radius resources are rendered on Kubernetes"
weight: 100
slug: "rendering"
---

When deploying Radius resources to environments running on Kubernetes, the [control plane]({{< ref architecture >}}) will render these resources into Kubernetes objects. This page describes these mappings and naming conventions.

<img src="rendering.png" alt="Diagram showing Radius resources being rendered into Kubernetes objects" width=600px />

## Resource mapping

The following resources map to Kubernetes resources. All other resources do not have a mapping and instead are tracked in the control plane.

| Radius resource                  | Kubernetes object | Rendered name |
|----------------------------------|-------------------|---------------|
| [`Applications.Core/containers`]({{< ref container-schema >}}) | `apps/Deployment@v1` | `<application-name>-<resource-name>` |
| [`Applications.Core/httpRoutes`]({{< ref httproute >}})   | `core/Service@v1` | `<application-name>-<resource-name>` |
| [`Applications.Core/gateways`]({{< ref gateway >}})     | `projectcontour.io/HTTPProxy@v1` | `<application-name>-<resource-name>` |
| [`Applications.Connector/daprPubSubBrokers`]({{< ref dapr-pubsub >}}) | `dapr.io/Component@v1alpha1` | `<application-name>-<resource-name>` - App scoped<br />`<resource-name>` - Env scoped |
| [`Applications.Connector/daprSecretStores`]({{< ref dapr-secretstore >}}) | `dapr.io/Component@v1alpha1` | `<application-name>-<resource-name>` - App scoped<br />`<resource-name>` - Env scoped |
| [`Applications.Connector/daprStateStores`]({{< ref dapr-statestore >}}) | `dapr.io/Component@v1alpha1` | `<application-name>-<resource-name>` - App scoped<br />`<resource-name>` - Env scoped |
