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

The rad CLI is the main tool for interacting with Radius. It is used to create and manage Radius environments, and to deploy and manage Radius applications.

Visit the [rad CLI how-to guide]({{< ref howto-rad-cli >}}) for more information on how to install the rad CLI.

{{< button text="How-To: rad CLI" page="howto-rad-cli" newtab="true" >}}

## Step 2: Install the Radius-Bicep VS Code extension

The Radius-Bicep VS Code extension provides a set of tools for working with Bicep files in VS Code. Visit the [VSCode how-to guide]({{< ref howto-vscode-bicep >}}) for more information on how to install the Radius-Bicep VS Code extension.

{{< button text="How-To: VS Code" page="howto-vscode-bicep" newtab="true" >}}

## Step 3: Initialize the Radius control-plane

The Radius control-plane is a set of services that provide the core functionality of Radius. It is deployed as a set of containers in a Kubernetes cluster.

Visit the [environments how-to guide]({{< ref howto-environment >}}) for more information on how to install the Radius control-plane and create your first Radius environment.

{{< button text="How-To: Init an environment" page="howto-environment" newtab="true" >}}

>If you are looking to upgrade Radius to the latest version, refer to [upgrade Radius on Kubernetes]({{< ref kubernetes-upgrade >}}) for more information.