---
type: docs
title: "How-To: Upgrade Radius on Kubernetes "
linkTitle: "Upgrade Radius on Kubernetes"
description: "Learn how to upgrade Radius on Kubernetes"
weight: 300
categories: "How-To"
---

Radius does not offer backward compatibility with previous releases. Breaking changes may happen between releases and we recommend doing a fresh installation of the latest version of Radius after every release.

## Step 1 : Delete any existing Radius Environments

To delete any existing Radius Environments, run the following command:

```bash
rad env delete
```

## Step 2: Uninstall the existing Radius control-plane

To uninstall the existing Radius control-plane, run the following command:

```bash
rad uninstall kubernetes
```

## Step 3: Install the rad CLI

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## Step 4: Install the Bicep VS Code extension

{{< read file= "/shared-content/installation/vscode-bicep/install-vscode-bicep.md" >}}

## Step 5: Initialize the Radius control-plane and the Radius Environment

{{< read file= "/shared-content/installation/install-radius/initialize-radius.md" >}}
