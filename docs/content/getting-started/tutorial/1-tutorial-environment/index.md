---
type: docs
title: "Initialize an environment"
linkTitle: "Initialize an environment"
description: "Initialize a Radius environment to deploy your tutorial application to"
weight: 200
slug: init-environment
---

{{% alert title="💻 Github Codespaces" color="warning" %}}
You can skip this section if you are using a [Github Codespace]({{< ref "getting-started" >}}) to try out the tutorial. The container have all the pre-requisites installed and environment initialized.
{{% /alert %}}

## Prerequisites

1. Make sure you have the following tools installed:
   - [rad CLI]({{< ref "getting-started#install-rad-cli" >}})
   - [kubectl CLI](https://kubernetes.io/docs/tasks/tools/#kubectl)
   - [az CLI](http://aka.ms/azcli)

1. Next, make sure you have a [supported Kubernetes cluster]({{< ref kubernetes >}}) deployed and setup with a kubectl context

1. If deploying Azure infrastructure, create or ensure you have access to an [Azure subscription](https://azure.com) _(optional - used in last tutorial step to deploy Azure resources)_

## Initialize a Radius environment

A Radius [environment]({{<ref environments-concept>}}) is a "landing zone"  which defines the container runtime and other configuration for your applications. Begin by initializing an environment in your Kubernetes cluster:

1. You can view the current context for kubectl by running:

   ```bash
   kubectl config current-context
   ```

   {{% alert color="success" %}} Visit the [Kubernetes platform docs]({{< ref kubernetes >}}) for a list of supported clusters and specific cluster requirements.
   {{% /alert %}}

<<<<<<< HEAD
1. Use the [`rad env init kubernetes` command]({{< ref rad_env_init_Kubernetes >}}) to initialize a new environment into your current kubectl context:
=======
1. Use the [`rad env init kubernetes` command]({{< ref rad_env_init_Kubernetes >}}) with the `-i` interactive flag to initialize a new environment into your current kubectl context:
>>>>>>> origin/v0.14

   ```bash
   rad env init kubernetes -i
   ```

   Follow the prompts to install the [control plane services]({{< ref architecture >}}), creates an [environment resource]({{< ref environments >}}), and creates a [local workspace]({{< ref workspaces >}}). You will be asked for:

   - **Namespace** - When an application is deployed, this is the namespace where your containers and other Kubernetes resources will be run. By default, this will be in the `default` namespace.
   {{% alert title="💡 About namespaces" color="success" %}} When you initialize a Radius Kubernetes environment, Radius installs the control plane resources within    the `radius-system` namespace in your cluster, separate from your applications. The namespace specified in this step will be used for your application deployments.
   {{% /alert %}}
   -  **Add Azure provider** - An [Azure cloud provider]({{<ref providers>}}) allows you to deploy and manage Azure resources as part of your application. If you have have an Azure subscription enter `y` and follow the instructions.
   - **Environment name** - The name of the environment to create. You can specify any name with lowercase letters, such as `myenv`.

1. Verify the control-plane was deployed by running:

   ```bash
   kubectl get deployments -n radius-system
   ```

   The output should look like:

   ```
   NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
   ucp                       1/1     1            1           53s
   appcore-rp                1/1     1            1           53s
   bicep-de                  1/1     1            1           53s
   contour-contour           1/1     1            1           46s
   dapr-dashboard            1/1     1            1           35s
   dapr-sidecar-injector     1/1     1            1           35s
   dapr-sentry               1/1     1            1           35s
   dapr-operator             1/1     1            1           35s
   ```

   Note that Dapr and Contour are also both installed into the `radius-system` namespace to help get you up and running quickly for our quickstarts and tutorial. This is a [point-in-time limitation]({{< ref limitations >}}) that will be addressed with richer environment customization in a future update.

1. Verify the environment resource was created by running:

   ```bash
   rad env list
   ```

   The output should look like:

   ```
   NAME      KIND   
   myenv     kubernetes
   ```
<br>{{< button text="Next step: Author and deploy app" page="2-tutorial-app">}}
