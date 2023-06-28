---
type: docs
title: "How-To: Initialize Radius Environments"
linkTitle: "How-To: Radius Environments"
description: "How-To: Initialize Radius Environments"
weight: 100
categories: "How-To"
tags: ["environments"]
---

## Pre-requisites

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

## Configure cloud providers (optional)

Setting up a [cloud provider]({{<ref providers>}}) allows you to deploy and manage resources from either Azure or AWS as part of your Radius Application.

{{< tabs Azure AWS >}}

{{% codetab %}}

### Pre-requisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/what-is-azure-cli)

### Configuration steps

1. Use [`rad env update`]({{< ref rad_env_update >}}) to update your Radius Environment with your Azure subscription ID and Azure resource group:

    ```bash
    rad env update myEnvironment --azure-subscription-id myAzureSubscriptionId --azure-resource-group  myAzureResourceGroup
    ```

2. Run `az ad sp create-for-rbac` to create a Service Principal without a role assignment and obtain your `appId`, `displayName`, `password`, and `tenant` information.

   ```bash
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
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   - Configure your CLI with [`aws configure`](https://docs.aws.amazon.com/cli/latest/reference/configure/index.html), specifying your configuration values
- [eksctl CLI](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

### Configuration steps

1. Create an EKS cluster by using the `eksctl` CLI. This command will create a cluster in the `us-west-2` region, as well as a VPC and the Subnets, Security Groups, and IAM Roles required for the cluster.

   ```bash
   eksctl create cluster --name my-cluster --region=us-west-2 --zones=us-west-2a,us-west-2b,us-west-2c
   ```

   > Note: If you are using an existing cluster, you can skip this step. However, make sure that the each of the Subnets in your EKS cluster Subnet Group are within the [list of supported MemoryDB availability zones](https://docs.aws.amazon.com/memorydb/latest/devguide/subnetgroups.html). If your cluster includes Subnets outside of a supported MemoryDB availability zone, or if using your own custom subnets, supply them as part of the deployment file as the following:   

   ```bash
   rad deploy ./app.bicep --parameters eksClusterName=YOUR_EKS_CLUSTER_NAME
   ```

2. Update your Radius Environment with your AWS region and AWS account ID:
    ```bash
    rad env update myEnvironment --aws-region myAwsRegion --aws-account-id myAwsAccountId
    ```
    This command updates the configuration of an environment for properties that are able to be changed. For more information visit [`rad env update`]({{< ref rad_env_update >}})
3. Add your AWS cloud provider credentials:
    ```bash
    rad credential register aws --access-key-id myAccessKeyId --secret-access-key mySecretAccessKey
    ```
    For more information on the command arguments visit [`rad credential register aws`]({{< ref rad_credential_register_aws >}})
{{% /codetab %}}
{{< /tabs >}}

## Next steps

- Learn about [Radius Workspaces]({{< ref workspaces >}})