---
type: docs
title: "1. Install Radius"
linkTitle: "1. Install Radius"
description: "Learn how to install Radius"
weight: 100
---

In part one, you will install Radius on an existing Kubernetes cluster.  

## Prerequisites

- A Kubernetes cluster 
- `kubectl` configured with the correct context  
- Your user must have the Kubernetes cluster-admin role  
- [Node.js](https://nodejs.org/en/download) installed  

For all technical requirements, see the [Installation how-to guide]({{< ref installation >}})

## Install the Radius CLI

{{< read file= "/shared-content/installation/rad-cli/install-rad-cli.md" >}}

## Install Radius

[`rad initialize`]({{< ref "rad_initialize" >}}) installs Radius and creates a pre-configured set of Resource Types, Recipes, and Environments. It is intended to get you started as quick as possible. This tutorial is a step-by-step guide so uses the [`rad install kubernetes`]({{< ref "rad_install_kubernetes" >}}) command which only installs Radius:  


```bash
rad install kubernetes
```

Verify if the pods are installed and running:

```bash
kubectl get pods -n radius-system
```
You should see output similar to:

```
NAME                READY   STATUS    RESTARTS   AGE
applications-rp      1/1     Running   0          1m
bicep-de             1/1     Running   0          1m
controller           1/1     Running   0          1m
dashboard            1/1     Running   0          1m 
dynamic-rp           1/1     Running   0          1m
ucp                  1/1     Running   0          1m
```

## Install the Bicep and Terraform extensions for VS Code (optional) 

Radius uses the Infrastructure as Code (IaC) language Bicep to define application resources and either Bicep or Terraform to deploy resources. Installing the Bicep and Terraform VS Code extensions provides syntax highlighting, auto-completion, and other useful features for these languages.  

- [Install the Bicep extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)  

- [Install the Terraform extension for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)  

In part two of this tutorial, you will create a PostgreSQL resource type. 
<br><br>
{{< button text="Next Step: Create Resource Type" page="create-resource-type" color="primary" >}} 