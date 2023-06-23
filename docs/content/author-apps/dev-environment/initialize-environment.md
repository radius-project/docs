---
type: docs
title: "How-To: Setup a development environment"
linkTitle: "Developer environments"
description: "Learn how to initialize a new Radius development environment"
weight: 200
categories: "How-To"
tags: ["environments"]
---

## Overview 

Radius development environments enable you to quickly get started with Radius and begin writing new applications. Dev environments come preloaded with a set of development [recipes]({{< ref "author-apps/recipes" >}}) with lightweight containers for commonly used resources such as Redis and Mongo, helping you get up and running instantly.

## Pre-requisites

1. Have a [Kubernetes cluster]({{< ref "/operations/platforms/kubernetes" >}}) handy.

   *Visit the [Kubernetes platform docs]({{< ref "/operations/platforms/kubernetes" >}}) for a list of supported clusters and specific cluster requirements.*

1. Ensure your target kubectl context is set as the default:
   ```bash
   kubectl config current-context
   ```

## How-to: Initialize a new environment

Begin by ensuring you are using a compatible [Kubernetes cluster]({{< ref "/operations/platforms/kubernetes" >}})

   *Visit the [Kubernetes platform docs]({{< ref "/operations/platforms/kubernetes" >}}) for a list of supported clusters and specific cluster requirements.*

{{< tabs "Dev environment" "Customized environment" "Manual" >}}

{{% codetab %}}
1. Initialize a new [Radius environment]{{(< ref "operations/environments">)}} with `rad init --dev` command:
   ```bash
   rad init --dev
   ```
   
   Select `Yes` to setup the app.bicep in the current directory

   ```
   Initializing Radius...                                                
                                                                      
   🕔 Install Radius 0.21                                             
      - Kubernetes cluster: kind
      - Kubernetes namespace: radius-system                              
   ⏳ Create new environment default                                     
      - Kubernetes namespace: default                                    
      - Recipe pack: dev                                                 
   ⏳ Scaffold application                                          
   ⏳ Update local configuration                                                 
   ```                                             

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
   ```

   You can also use [`rad env list`]({{< ref rad_env_list.md >}}) to view your environment:
   
   ```bash
   rad env list
   ```
3. Use `rad recipe list` to see the list of available recipes:
   ```bash
   rad recipe list
   ```
   ```
   NAME      TYPE                              TEMPLATE KIND  TEMPLATE
   default   Applications.Link/mongoDatabases  bicep          radius.azurecr.io/recipes/dev/mongodatabases:latest
   default   Applications.Link/redisCaches     bicep          radius.azurecr.io/recipes/dev/rediscaches:latest
   ``` 
   You can follow the [recipes]({{< ref "author-apps/recipes" >}}) documentation to learn more about the recipes and how to use them in your application.

{{% /codetab %}}

{{% codetab %}}
1. Initialize a new environment with `rad init` command:
   ```bash
   rad init
   ```

1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Azure provider** (optional) - Allows you to [deploy and manage Azure resources]({{<ref providers>}})
   - **Environment name** - The name of the environment to create
1. Let the rad CLI run the following tasks:
   1. **Install Radius** - Radius installs the [control plane services]({{< ref architecture-concept >}}) in the `radius-system` namespace
   2. **Create the environment** - An environment resource is created in the Radius control plane. It maps to a Kubernetes namespace.
   3. **Add the Azure Cloud Provider** - The Azure cloud provider configuration is saved in the Radius control plane
   4. **Add the AWS Cloud Provider** - The AWS cloud provider configuration is saved in the Radius control plane
   
   You should see the following output:

   ```bash
   Initializing Radius...                     
                                           
   ✅ Install Radius v0.21                  
      - Kubernetes cluster: k3d-k3s-default   
      - Kubernetes namespace: radius-system   
   ✅ Create new environment default          
      - Kubernetes namespace: default         
   ✅ Scaffold application samples            
   ✅ Update local configuration              
                                             
   Initialization complete! Have a RAD time 😎
   ```

2. Verify the initialization by running:
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
   rad env list
   ```

{{% /codetab %}}

{{% codetab %}}

1. Install Radius onto a Kubernetes cluster:

    Use the following command to target your desired Kubernetes cluster.

    For a list of all the supported command options visit [rad install kubernetes]({{< ref rad_install_kubernetes >}})

    ```bash
    rad install kubernetes --chart <user-chart> --tag <user-tag> --set <user-set>
    ```

2. Create a new Radius resource group:

    Radius resource groups are used to organize Radius resources, such as applications, environments, links, and routes. For more information visit [Radius resource groups]({{< ref groups >}}).

    For a dive into the command visit [`rad group create`]({{< ref rad_group_create >}})

    ```bash
    rad group create <user-radius-resource-group>
    ```

4. Create your Radius Environment and pass it your Kubernetes namespace:

    ```bash
    rad env create <user-radius-environment> --namespace <kubernetes-namespace>
    ```

    For a dive into the command visit [`rad env create`]({{< ref rad_env_create >}})

5. Set your Radius Environment:

    ```bash
    rad env switch kind-radius
    ```

    For a dive into the command visit [`rad env switch`]({{< ref rad_env_switch >}}).

{{% /codetab %}}
{{< /tabs >}}


## Resource schema 

- [Environment schema]({{< ref environment-schema >}})

## Further reading

Refer to the [environments]({{< ref "/tags/environments" >}}) tag for more guides on the environment resource.



