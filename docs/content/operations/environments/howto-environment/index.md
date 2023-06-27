---
type: docs
title: "How-To: Initialize Radius Environments"
linkTitle: "How-To: Radius Environments"
description: "How-To: Initialize Radius Environments"
weight: 200
categories: "How-To"
tags: ["environments"]
---

## How-to: Initialize a Radius Environment

Begin by ensuring you are using a compatible [Kubernetes cluster]({{< ref "/operations/platforms/kubernetes" >}})

   *Visit the [Kubernetes platform docs]({{< ref "/operations/platforms/kubernetes" >}}) for a list of supported clusters and specific cluster requirements.*

{{< tabs "Interactive" "Manual" >}}

{{% codetab %}}

1. Initialize a new environment with `rad init` command:
   ```bash
   rad init
   ```

1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Azure provider** (optional) - Allows you to [deploy and manage Azure resources]({{< ref "providers#azure-provider" >}})
   - **AWS provider** (optional) - Allows you to [deploy and manage AWS resources]({{< ref "providers#aws-provider" >}})
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
    rad install kubernetes
    ```
2. Create a new Radius resource group:
    Radius resource groups are used to organize Radius resources, such as applications, environments, links, and routes. For more information visit [Radius resource groups]({{< ref groups >}}).
    For more information on the command visit [`rad group create`]({{< ref rad_group_create >}})
    ```bash
    rad group create myGroup
    ```
4. Create your Radius Environment and pass it your Kubernetes namespace:
    ```bash
    rad env create myEnvironment --namespace my-namespace --group myGroup
    ```
    For more information on the command visit [`rad env create`]({{< ref rad_env_create >}})
5. Verify the initialization by running:
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
{{% /codetab %}}
{{< /tabs >}}

### Optional: Cloud provider configuration

Setting up a [cloud provider]({{<ref providers>}}) allows you to deploy and manage resources from either Azure or AWS as part of your Radius Application.

{{< tabs Azure AWS >}}

{{% codetab %}}

1. Update your Radius Environment with your Azure subscription ID and Azure resource group:

    ```bash
    rad env update <user-radius-environment> --azure-subscription-id <user-azure-subscription-id> --azure-resource-group  <user-azure-resource-group>
    ```
    This command updates the configuration of an environment for properties that are able to be changed. For more information visit [`rad env update`]({{< ref rad_env_update >}})
2. Add your Azure cloud provider credentials:
    ```bash
    rad credential register azure --client-id ***  --client-secret ***  --tenant-id ***
    ```
    Radius will use the provided service principal for all interactions with Azure, including Bicep deployment, Radius Environments, and Radius Links.
    
    For more information on the command arguments visit [`rad credential register azure`]({{< ref rad_credential_register_azure >}})
{{% /codetab %}}
{{% codetab %}}
1. Update your Radius Environment with your AWS region and AWS account ID:
    ```bash
    rad env update <user-radius-environment> --aws-region <user-aws-region> --aws-account-id ***
    ```
    This command updates the configuration of an environment for properties that are able to be changed. For more information visit [`rad env update`]({{< ref rad_env_update >}})
2. Add your AWS cloud provider credentials:
    ```bash
    rad credential register aws --access-key-id *** --secret-access-key ***
    ```
    For more information on the command arguments visit [`rad credential register aws`]({{< ref rad_credential_register_aws >}})
{{% /codetab %}}
{{< /tabs >}}