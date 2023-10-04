---
type: docs
title: "How-To: Upgrade Radius on Kubernetes "
linkTitle: "Upgrade Radius on Kubernetes"
description: "Learn how to upgrade Radius on Kubernetes"
weight: 300
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

## Step 3: Install the rad CLI

{{< read file= "/shared-content/radius-installation/rad-cli/install-rad-cli.md" >}}

## Step 4: Install the Radius-Bicep VS Code extension

{{< read file= "/shared-content/radius-installation/vscode-bicep/install-vscode-bicep.md" >}}

## Step 5: Initialize the Radius control-plane and the Radius environment

{{< read file= "/shared-content/radius-installation/install-radius/initialize-radius.md" >}}

>If you are looking to upgrade Radius to the latest version, refer to [upgrade Radius on Kubernetes]({{< ref kubernetes-upgrade >}}) for more information.
