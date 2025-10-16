---
type: docs
title: "1. Install Radius"
linkTitle: "1. Install Radius"
description: "Learn how to install Radius"
weight: 200
---

## Prerequisites

- A Kubernetes cluster running (local or cloud-based). If you don't have one, you can create a local cluster using [kind](https://kind.sigs.k8s.io/) or [k3d](https://k3d.io/)
- `kubectl` installed

## Install the Radius CLI

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## Install Radius

The Radius control plane provides the backend API layer to manage your Radius environments and applications. You can use the rad CLI to install the control plane:

```bash
rad install kubernetes
```

The command creates the `radius-system` namespace with all the Radius control plane components.

Verify if the pods are installed and running:

```bash
kubectl get pods -n radius-system
```
You should see output similar to:

```
NAME                READY   STATUS    RESTARTS   AGE
ucp                  1/1     Running   0          1m
applications-rp      1/1     Running   0          1m
bicep-de             1/1     Running   0          1m
controller           1/1     Running   0          1m
dynamic-rp           1/1     Running   0          1m
```

## Step 3: Install VS Code extension (optional)

Radius operates on IaC (Infrastructure as Code) languages Bicep and Terraform. Installing the VS Code extension can enhance your development experience by providing syntax highlighting, autocompletion, and other useful features for these languages.

To install the VS Code extension:

1. Open Visual Studio Code.
2. Go to the Extensions view by clicking on the Extensions icon in the Activity Bar on the side of the window.
3. Search for "Bicep" and "Terraform" extensions and install them.

{{< button text="Next Step: Create Resource Type" page="create-resource-type" color="primary" >}}