---
type: docs
title: "Initialize a Radius environment"
linkTitle: "Initialize a Radius environment"
description: "Learn how to initialize a new Radius environment"
weight: 200
categories: "How-To"
tags: ["environments"]
---

## Pre-requisites

1. Begin by deploying a compatible [Kubernetes cluster]({{< ref "/operations/platforms/kubernetes" >}})

   *Visit the [Kubernetes platform docs]({{< ref "/operations/platforms/kubernetes" >}}) for a list of supported clusters and specific cluster requirements.*

1. Ensure your target kubectl context is set as the default:
   ```bash
   kubectl config current-context
   ```

## How-to: Initialize a new environment

1. Initialize a new environment with `rad init` command:
   ```bash
   rad init
   ```
1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Azure provider** (optional) - Allows you to [deploy and manage Azure resources]({{<ref providers>}})
   - **AWS provider** (optional) - Allows you to [deploy and manage AWS resources]({{<ref providers>}})
   - **Environment name** - The name of the environment to create
1. Let the rad CLI run the following tasks:
   1. **Install Radius** - Radius installs the [control plane services]({{< ref architecture-concept >}}) in the `radius-system` namespace
   2. **Create the environment** - An environment resource is created in the Radius control plane. It maps to a Kubernetes namespace.
   3. **Add the Azure Cloud Provider** - The Azure cloud provider configuration is saved in the Radius control plane
   4. **Add the AWS Cloud Provider** - The AWS cloud provider configuration is saved in the Radius control plane
   5. **Create a workspace** - [Workspaces]({{< ref workspaces >}}) are local pointers to a cluster running Radius, and an environment. Workspaces are saved to the Radius config file (`~/.rad/config.yaml` on Linux and macOS, `%USERPROFILE%\.rad\config.yaml` on Windows)
2. Verify the initialization by running:
   ```bash
   kubectl get deployments -n radius-system
   ```

   You should see:

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

   You can also use [`rad env list`]({{< ref rad_env_list.md >}}) to see if the created environment gets listed:
   
   ```bash
   rad env list
   ```


