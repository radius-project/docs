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

This tutorial contains the following sections:

- App overview - Overview of the website tutorial application
- Author app definition - Define the application definition with container, gateway and http routes
- Add a database connector - Connect a MongoDB to the website tutorial application using a connector and deploy to a Radius environment
- Swap a connector resource - Swap a MongoDB container for an Azure CosmosDB instance to back the connector and deploy the app to a Radius environment with Azure cloud provider configured

## Prerequisites

- [Install Radius CLI]({{< ref "getting-started#install-radius-cli" >}})
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
When Radius initializes a Kubernetes environment, it will install the Radius control plane into your cluster if needed, using the `radius-system` namespace. These control plane resources aren't part your application. The namespace specified in interactive mode will be used for future application deployments by default.
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
   bicep-de                  1/1     1            1           53s
   contour-contour           1/1     1            1           46s
   dapr-dashboard            1/1     1            1           35s
   radius-rp                 1/1     1            1           53s
   dapr-sidecar-injector     1/1     1            1           35s
   dapr-sentry               1/1     1            1           35s
   dapr-operator             1/1     1            1           35s
   ```

<br>{{< button text="Next: App overview" page="webapp-initial-deployment" >}}