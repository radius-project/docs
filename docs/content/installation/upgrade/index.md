---
type: docs
title: "How-To: Upgrade Radius on Kubernetes "
linkTitle: "Upgrade Radius on Kubernetes"
description: "Learn how to upgrade Radius on Kubernetes"
weight: 200
categories: "How-To"
---

Radius does not offer backward compatibility with previous releases. Breaking changes may happen between releases and we recommend doing a fresh installation of the latest version of Radius after every release.

## Step 1 : Delete any existing Radius environments 

To delete any existing Radius environments, run the following command:

```bash
rad env delete 
```

## Step 2: Uninstall the existing Radius control-plane

To uninstall the existing Radius control-plane, run the following command:

```bash
rad uninstall kubernetes
```

## Step 3: Install the latest version of Radius

{{< read file= "../install-shared/installation.md" >}}

