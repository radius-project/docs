---
type: docs
title: "How to uninstall Radius"
linkTitle: "Uninstall Radius"
description: "Learn how to uninstall the Radius control plane from your Kubernetes cluster"
weight: 700
aliases:
  - /guides/installation/control-plane/uninstall/
---

Uninstalling Radius removes the Radius control plane from the Kubernetes cluster. You can choose whether to retain your Radius configuration and resource data or delete it entirely.

## Retain resources

To uninstall the Radius control plane while keeping your Radius configuration and data, run:

```bash
rad uninstall kubernetes
```

All Radius services running in the `radius-system` namespace are removed, but Radius configuration and data remain persisted in the Kubernetes cluster. This lets you reinstall Radius later without losing your existing environments and applications.

## Delete resources

To completely remove Radius, including all configuration and data, delete the `radius-system` namespace after uninstalling:

```bash
rad uninstall kubernetes --purge
```

All Radius configuration and data stored in the namespace is removed. This completely removes Radius from the cluster.
