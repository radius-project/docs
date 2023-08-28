---
type: docs
title: "How-To: Initialize Radius Environments"
linkTitle: "How-To: Environments"
description: "Learn how to create Radius environments"
weight: 200
categories: "How-To"
tags: ["environments"]
---

Radius environments are prepared landing zones for applications that contain configuration and Recipes. To learn more visit the [environments overview]({{< ref "/operations/environments/overview" >}}) page.

Radius environments can be setup with the rad CLI via two paths: interactive or manual.

## Pre-requisites

- Install the [rad CLI]({{< ref getting-started >}})
- Setup a supported [Kubernetes cluster]({{< ref "/operations/platforms/kubernetes" >}})

## Create an environment interactively

1. Initialize a new environment with [`rad init --full`]({{< ref rad_init >}}):
   ```bash
   rad init --full
   ```

1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Azure provider** (optional) - Allows you to [deploy and manage Azure resources]({{< ref "providers#azure-provider" >}})
   - **AWS provider** (optional) - Allows you to [deploy and manage AWS resources]({{< ref "providers#aws-provider" >}})
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

   [Radius resource groups]({{< ref groups >}}) are used to organize Radius resources such as applications, environments, links, and routes. Run [`rad group create`]({{< ref rad_group_create >}}) to create a new resource group:

   ```bash
    rad group create myGroup
   ```

   You should see the following message:

   ```
    creating resource group "myGroup" in workspace ""...

    resource group "myGroup" created
   ```


1. Create your Radius environment:
   
   Run [`rad env create`]({{< ref rad_env_create >}}) to create a new environment in your resource group. Specify the `--namespace` flag to select the Kubernetes namespace to deploy resources into:
   
   ```bash
   rad env create myEnvironment --group myGroup --namespace my-namespace
   ```

   You should see your Radius environment being created and linked to your resource group:

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

### Configure cloud providers

Setting up a [cloud provider]({{< ref providers >}}) allows you to deploy and manage resources from either Azure or AWS as part of your Radius Application.

{{< tabs Azure AWS >}}

{{% codetab %}}

#### Pre-requisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/what-is-azure-cli)

#### Configuration steps

1. Use [`rad env update`]({{< ref rad_env_update >}}) to update your Radius Environment with your Azure subscription ID and Azure resource group:

    ```bash
    rad env update myEnvironment --azure-subscription-id myAzureSubscriptionId --azure-resource-group  myAzureResourceGroup
    ```

2. Run `az ad sp create-for-rbac` to create a Service Principal without a role assignment and obtain your `appId`, `displayName`, `password`, and `tenant` information.

   ```
   {
   "appId": "****",
   "displayName": "****",
   "password": "****",
   "tenant": "****"
   }
   ```


3. Use [`rad credential register azure`]({{< ref rad_credential_register_azure >}}) to add the Azure service principal to your Radius installation:
    ```bash
    rad credential register azure --client-id myClientId  --client-secret myClientSecret  --tenant-id myTenantId
    ```
    Radius will use the provided service principal for all interactions with Azure, including Bicep and Recipe deployments.

{{% /codetab %}}
{{% codetab %}}

### Pre-requisites

- Make sure you have an [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account) and an [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html)
    - [Create an IAM AWS access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) and copy the AWS Access Key ID and the AWS Secret Access Key to a secure location for use later. If you have already created an Access Key pair, you can use that instead.
- Make sure you can create or already have a [EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) in order to deploy AWS resources, for more information on how Radius handles EKS clusters see [supported clusters]({{< ref supported-clusters >}}).

### Configuration steps

1. Update your Radius Environment with your AWS region and AWS account ID:
    ```bash
    rad env update myEnvironment --aws-region myAwsRegion --aws-account-id myAwsAccountId
    ```
    This command updates the configuration of an environment for properties that are able to be changed. For more information visit [`rad env update`]({{< ref rad_env_update >}})
2. Add your AWS cloud provider credentials:
    ```bash
    rad credential register aws --access-key-id myAccessKeyId --secret-access-key mySecretAccessKey
    ```
    For more information on the command arguments visit [`rad credential register aws`]({{< ref rad_credential_register_aws >}})
{{% /codetab %}}
{{< /tabs >}}

## Next steps

- Learn about [Radius Workspaces]({{< ref workspaces >}})
