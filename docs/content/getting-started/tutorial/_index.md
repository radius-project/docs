---
type: docs
title: "Tutorial for Project Radius"
linkTitle: "Tutorial"
description: "Hit the ground running with our Radius tutorial, complete with code samples aimed to get you started quickly with Radius"
weight: 100
no_list: true
---

## Overview

This tutorial will teach you how to deploy a website as a Radius application from first principles. You will take away two things
- Enough knowledge to map your own application in Radius 
- Radius features that will help you quickly iterate in local dev and port applications to cloud/edge

## Tutorial steps

In this tutorial, you will:

- Define an application definition via Radius application model
- Run the application locally
- Add connector resources for portability
- Set up the environment 
- Deploy the application
- View the application

## Prerequisites

- [Install Radius CLI]({{< ref "getting-started#install-radius-cli" >}})
- Setup a Kubernetes cluster. Could be any of the following
  - [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster)
    - Note that [AKS-managed AAD](https://docs.microsoft.com/en-us/azure/aks/managed-aad) is not supported currently
  - [Kubernetes in Docker Desktop](https://www.docker.com/blog/docker-windows-desktop-now-kubernetes/), however it does take up quite a bit of memory on your machine, so use with caution.
  - [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
  - [K3s](https://k3s.io), a lightweight single-binary certified Kubernetes distribution from Rancher.
- Install CLI for target cloud providers
  - [az CLI](https://docs.microsoft.com/cli/azure/install-azure-cli) as the tutorial sample application connects to an Azure resource
- [Install Visual Studio Code](https://code.visualstudio.com/) (recommended)
  - The [Radius VSCode extension]({{< ref "getting-started#setup-vscode" >}}) provides syntax highlighting, completion, and linting.
  - You can also complete this tutorial with any basic text editor.

### Initialize a Radius environment

A Radius Kubernetes envionment can run in a Kubernetes cluster running on any platform. 

You can view the current context for kubectl by running
```bash
kubectl config current-context
```

Then run the following command to initialize a Radius Kubernetes environment:
```sh
rad env init kubernetes
```

<br>{{< button text="Next: application overview" page="webapp-overview.md" >}}
