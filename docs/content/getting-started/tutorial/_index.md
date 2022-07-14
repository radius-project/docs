---
type: docs
title: "Tutorial for Project Radius"
linkTitle: "Tutorial"
description: "Hit the ground running with our Radius tutorial, complete with code samples aimed to get you started quickly with Radius"
weight: 100
no_list: true
---

## Overview

This tutorial will teach you how to deploy a website as a Radius application from first principles. You will take away the following 
- Enough knowledge to map your own application in Radius 
- Separation of concerns between the different personas involved in a deployment
- Achieve portability via connectors between your local and cloud environmnets 

## Tutorial steps

In this tutorial, you will:

- App overview - Overview of the website tutorial application
- Author app definition - Define the application definition with container, gateway and http routes
- Add a database connector - Connect a MongoDB to the website tutorial application using a connector and deploy to a Radius environment
- Swap a connector resource - Swap a connector resource for an Azure resource to back the connector and deploy it to an environment with Azure cloud provider configured

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

## Initialize a Radius environment

A Radius Kubernetes envionment can run in a Kubernetes cluster running on any platform.

You can view the current context for kubectl by running
```bash
kubectl config current-context
```

Use the [`rad env init kubernetes` command]({{< ref rad_env_init_Kubernetes >}}) to initialize a new environment into your current kubectl context.
```bash
rad env init kubernetes -i
```

Follow the prompts, you can choose to add the [Azure cloud provider]({{<ref providers>}}) as you will be deploying an Azure cosmosdb resource in the later part of the tutorial. You can also skip adding cloud provider if you do not have an Azure subscription

{{% alert title="💡 About namespaces" color="success" %}}
When Radius initializes a Kubernetes environment, it will deploy the system resources into the `radius-system` namespace. These aren't part your application. The namespace specified in interactive mode will be used for future deployments by default.
{{% /alert %}}

1. Verify initialization

   To verify the environment initialization succeeded, you can run the following command:

   ```bash
   kubectl get deployments -n radius-system
   ```

   The output should look like this:

   ```bash
   NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
   ucp                       1/1     1            1           53s
   appcore-rp                1/1     1            1           53s
   bicep-deployment-engine   1/1     1            1           53s
   bicep-de                  1/1     1            1           53s
   contour-contour           1/1     1            1           46s
   dapr-dashboard            1/1     1            1           35s
   radius-rp                 1/1     1            1           53s
   dapr-sidecar-injector     1/1     1            1           35s
   dapr-sentry               1/1     1            1           35s
   dapr-operator             1/1     1            1           35s
   ```

   An ingress controller is automatically deployed to the `radius-system` namespace for you to manage gateways. In the future you will be able to deploy your own ingress controller. Check back for updates.
