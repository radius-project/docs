---
type: docs
title: "How-To: Initialize Radius Environments"
linkTitle: "Initialize Environments"
description: "Learn how to create Radius Environments"
weight: 200
categories: "How-To"
tags: ["environments"]
---

Radius Environments are prepared landing zones for applications that contain configuration and Recipes. To learn more visit the [environments overview]({{< ref "/guides/deploy-apps/environments/overview" >}}) page.

Radius Environments can be setup with the rad CLI via two paths: interactive or manual.

## Pre-requisites

- [Setup a supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})

## Create a development environment

1. Initialize a new [Radius Environment]({{< ref "/guides/deploy-apps/environments/overview">}}) with [`rad init`]({{< ref rad_init >}}):
   ```bash
   rad init
   ```

   Select `Yes` to setup the application in the current directory. This will create `app.bicep` and [`bicepconfig.json`]({{< ref "/guides/tooling/bicepconfig/overview" >}}) files

   ```
   Initializing Radius...

   🕔 Install Radius {{< param version >}}
      - Kubernetes cluster: kind
      - Kubernetes namespace: radius-system
   ⏳ Create new environment default
      - Kubernetes namespace: default
      - Recipe pack: local-dev
   ⏳ Scaffold application
   ⏳ Update local configuration
   ```

1. Verify the initialization by running:
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
   ```

   You can also use [`rad env list`]({{< ref rad_env_list.md >}}) to view your environment:

   ```bash
   rad env list
   ```
1. Use `rad recipe list` to see the list of available Recipes:
   ```bash
   rad recipe list
   ```

   ```
   NAME      TYPE                              TEMPLATE KIND  TEMPLATE
   default   Applications.Datastores/mongoDatabases  bicep          ghcr.io/radius-project/recipes/local-dev/mongodatabases:latest
   default   Applications.Datastores/redisCaches     bicep          ghcr.io/radius-project/recipes/local-dev/rediscaches:latest
   ```

   You can follow the [Recipes]({{< ref "/guides/recipes/overview" >}}) documentation to learn more about the Recipes and how to use them in your application.

## Create an environment interactively

1. Initialize a new environment with [`rad init --full`]({{< ref rad_init >}}):

   ```bash
   rad init --full
   ```

1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Azure provider** (optional) - Allows you to [deploy and manage Azure resources]({{< ref "/guides/operations/providers/azure-provider" >}})
   - **AWS provider** (optional) - Allows you to [deploy and manage AWS resources]({{< ref "/guides/operations/providers/aws-provider" >}})
   - **Environment name** - The name of the environment to create

   You should see the following output:

      ```
      Initializing Radius...

      ✅ Install Radius {{< param version >}}
         - Kubernetes cluster: k3d-k3s-default
         - Kubernetes namespace: radius-system
      ✅ Create new environment default
         - Kubernetes namespace: default
         - Recipe pack: dev
      ✅ Scaffold application samples
      ✅ Update local configuration

      Initialization complete! Have a RAD time 😎
      ```

1. Verify the Radius services were installed by running:

   ```bash
   kubectl get deployments -n radius-system
   ```

   You should see:

   ```
   NAME              READY   UP-TO-DATE   AVAILABLE   AGE
   ucp               1/1     1            1           2m56s
   appcore-rp        1/1     1            1           2m56s
   bicep-de          1/1     1            1           2m56s
   contour-contour   1/1     1            1           2m33s
   ```

1. Verify an environment was created with [`rad env show`]({{< ref rad_env_show.md >}}):

   ```bash
   rad env show -o json
   ```

   You should see your new environment:

   ```
   {
     "id": "/planes/radius/local/resourcegroups/default/providers/Applications.Core/environments/default",
     "location": "global",
     "name": "default",
     "properties": {
       "compute": {
         "kind": "kubernetes",
         "namespace": "default"
       },
       "provisioningState": "Succeeded",
       "recipes": {}
       }
     },
     "systemData": {},
     "tags": {},
     "type": "Applications.Core/environments"
   }
   ```

## Create an environment manually (advanced)

Radius can also be installed and an environment created with manual rad CLI commands. This is useful for pipelines or scripts that need to install and manage Radius.

1. Install Radius onto a Kubernetes cluster:

    Run [`rad install kubernetes`]({{< ref rad_install_kubernetes >}}) to install Radius into your default Kubernetes context and cluster:

    ```bash
    rad install kubernetes
    ```

    You should see the following message:

    ```
    Installing Radius version 2134e8e to namespace: radius-system...
    ```

1. Create a new Radius resource group:

   [Radius resource groups]({{< ref groups >}}) are used to organize Radius resources such as applications, environments, portable resources, and routes. Run [`rad group create`]({{< ref rad_group_create >}}) to create a new resource group:

   ```bash
    rad group create myGroup
   ```

   You should see the following message:

   ```
    creating resource group "myGroup" in workspace ""...

    resource group "myGroup" created
   ```


1. Create your Radius Environment:

   Run [`rad env create`]({{< ref rad_env_create >}}) to create a new environment in your resource group. Specify the `--namespace` flag to select the Kubernetes namespace to deploy resources into:

   ```bash
   rad env create myEnvironment --group myGroup --namespace my-namespace
   ```

   You should see your Radius Environment being created and linked to your resource group:

   ```
   Creating Environment...
   Successfully created environment "myEnvironment" in resource group "myGroup"
   ```

1. Verify the initialization by running:
   ```bash
   kubectl get deployments -n radius-system
   ```

   You should see:

   ```
   NAME              READY   UP-TO-DATE   AVAILABLE   AGE
   ucp               1/1     1            1           2m56s
   appcore-rp        1/1     1            1           2m56s
   bicep-de          1/1     1            1           2m56s
   contour-contour   1/1     1            1           2m33s
   ```

   You can also use [`rad env list`]({{< ref rad_env_list.md >}}) to see if the created environment gets listed:

   ```bash
   rad env list --group myGroup
   ```

   You should see:

   ```
   NAME
   myEnvironment
   ```

## Next steps

Follow the [cloud provider guides]({{< ref providers >}}) to configure cloud providers for your environment to deploy and manage cloud resources.