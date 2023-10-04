---
type: docs
title: "Overview: Radius installation"
linkTitle: "Installation"
description: "Learn how to get install Radius tooling and services"
weight: 25
---

Radius consists of a set of tools and services that together form the Radius platform.

<img src="radius.png" alt="Diagram showing rad CLI and VSCode extension on local machine plus the Radius control plane on a Kubernetes cluster" width="600px" >

## Step 1: Install the rad CLI

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## Step 2: Install the Radius-Bicep VS Code extension

{{< read file= "/shared-content/installation/vscode-bicep/install-vscode-bicep.md" >}}

## Step 3: Initialize the Radius control-plane and the Radius environment

{{< read file= "/shared-content/installation/install-radius/initialize-radius.md" >}}

>If you are looking to upgrade Radius to the latest version, refer to [upgrade Radius on Kubernetes]({{< ref kubernetes-upgrade >}}) for more information.