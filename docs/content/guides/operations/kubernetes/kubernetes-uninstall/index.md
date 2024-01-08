---
type: docs
title: "How-To: Uninstall Radius from Kubernetes"
linkTitle: "Uninstall Radius"
description: "Learn how to uninstall Radius control plane from your Kubernetes cluster"
weight: 400
categories: "How-To"
tags: ["Kubernetes"]
---

## Prerequisites

- [Radius installed on Kubernetes cluster]({{< ref "guides/operations/kubernetes/kubernetes-install" >}})

## Step 1: Uninstall the Radius control-plane from your kubernetes cluster

To uninstall the existing Radius control-plane, run the following command:

```bash
rad uninstall kubernetes
```

All the Radius services running in the `radius-system` namespace will be removed. Note that Radius configuration and data will still be persisted in the cluster until the namespace is also deleted.

## Step 2: Delete the `radius-system` namespace

To delete the `radius-system` namespace, run the following command:

```bash
kubectl delete namespace radius-system
```

All Radius configuration and data will be removed as part of the namespace. This completely removes from your cluster.

## Step 3: Remove the rad CLI

You can remove the rad CLI by deleting the [binary]
({{< ref "/guides/tooling/rad-cli/overview/#binary-location" >}}) and ~/.rad folder from your machine.