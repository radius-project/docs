---
type: docs
title: "Tutorial for Project Radius"
linkTitle: "Tutorial"
description: "Walk through an in-depth example to learn more about how to work with Radius concepts"
weight: 100
no_list: true
---

## Overview

This tutorial will teach you how to deploy a website as a Radius application from first principles. You will take away the following 
- Enough knowledge to map your own application in Radius 
- Achieve portability via connectors between your local and cloud environments 
- Understand the separation of concerns for the different personas involved in a deployment

## Tutorial steps

This tutorial contains the following sections:

- App overview - Overview of the website tutorial application
- Author app definition - Define the application definition with container, gateway and http routes
- Add a database connector - Connect a MongoDB to the website tutorial application using a connector and deploy to a Radius environment
- Swap a connector resource - Swap a MongoDB container for an Azure CosmosDB instance to back the connector and deploy the app to a Radius environment with Azure cloud provider configured

## Prerequisites

- [Install Radius CLI]({{< ref "getting-started#install-radius-cli" >}})
- Set up a Kubernetes Cluster. There are many different options here, including:
  - [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster)
    - Note that [AKS-managed AAD](https://docs.microsoft.com/en-us/azure/aks/managed-aad) is not supported currently
  - [Kubernetes in Docker Desktop](https://www.docker.com/blog/docker-windows-desktop-now-kubernetes/), however it does take up quite a bit of memory on your machine, so use with caution.
  - [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
  - [K3s](https://k3s.io), a lightweight single-binary certified Kubernetes distribution from Rancher.
  - Another Kubernetes provider of your choice.
- [Install Visual Studio Code](https://code.visualstudio.com/) (recommended)
  - The [Radius VSCode extension]({{< ref "getting-started#setup-vscode" >}}) provides syntax highlighting, completion, and linting.
  - You can also complete this tutorial with any basic text editor.

<br>{{< button text="Next: App overview" page="webapp-overview" >}}