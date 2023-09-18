---
type: docs
title: "How-To: Upgrade Radius on Kubernetes "
linkTitle: "Upgrade Radius on Kubernetes"
description: "Learn how to upgrade Radius on Kubernetes"
weight: 400
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

The rad CLI is the main tool for interacting with Radius. It is used to create and manage Radius environments, and to deploy and manage Radius applications.

Visit the [rad CLI how-to guide]({{< ref howto-rad-cli >}}) for more information on how to install the rad CLI.

{{< button text="How-To: rad CLI" page="howto-rad-cli" newtab="true" >}}

## Step 4: Install the Radius-Bicep VS Code extension

The Radius-Bicep VS Code extension provides a set of tools for working with Bicep files in VS Code. Visit the [VSCode how-to guide]({{< ref howto-vscode >}}) for more information on how to install the Radius-Bicep VS Code extension.

{{< button text="How-To: VS Code" page="howto-vscode" newtab="true" >}}

## Step 5: Initialize the Radius control-plane

The Radius control-plane is a set of services that provide the core functionality of Radius. It is deployed as a set of containers in a Kubernetes cluster.

Visit the [environments how-to guide]({{< ref howto-environment >}}) for more information on how to install the Radius control-plane and create your first Radius environment.

{{< button text="How-To: Init an environment" page="howto-environment" newtab="true" >}}




