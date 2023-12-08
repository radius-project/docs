---
type: docs
title: "How-To: Uninstall Radius"
linkTitle: "Uninstall Radius"
description: "Learn how to uninstall Radius control plane and rad cli"
weight: 400
categories: "How-To"
tags: ["Kubernetes"]
---

## Prerequisites

- [Radius installed on Kubernetes cluster]({{< ref /guides/operations/kubernetes/kubernetes-install >}})

## Step 1: Uninstall the Radius control-plane from your kubernetes cluster

To uninstall the existing Radius control-plane, run the following command:

```bash
rad uninstall kubernetes
```
All the Radius services running in the `radius-system` namespace will be deleted.

## Step 2: Delete the `radius-system` namespace

To delete the `radius-system` namespace, run the following command:

```bash
kubectl delete namespace radius-system
```

## Step 3: Remove the rad CLI

You can remove the rad CLI by deleting the binary and ~/.rad folder from your machine.