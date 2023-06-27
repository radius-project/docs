---
type: docs
title: "Radius environments"
linkTitle: "Environments"
description: "Learn about Radius environments and how to interact with them"
weight: 200
categories: "How-To"
tags: ["environments"]
---

Radius environments are prepared "landing zones" for Radius applications. Applications deployed to an environment will inherit the container runtime, configuration, and other settings from the environment. Stay tuned for additional environment capabilities coming soon.

## Configuration

The following configuration options are available for environments:

### Container runtime

Radius environments can be configured with a container runtime, where Radius [containers]({{< ref container >}}) will be run, along with [gateways and routes]({{< ref networking >}}).

A Kubernetes namespace is specified on the environment to tell Radius where to render application resources at deploy time.

<img src=environments.png alt="Diagram showing a Radius environment mapping to a Kubernetes cluster and namespace" width=800px />

### Cloud Provider

You can optionally configure cloud providers allow you to deploy and connect to cloud resources across various cloud platforms. For example, you can use the Radius Azure provider to run your application's services in your Kubernetes cluster, while deploying Azure resources to a specified Azure subscription and resource group. More information on setting up a cloud provider can be found in the [providers]({{< ref providers >}}) section.

#### Supported cloud providers

| Provider | Description |
|----------|-------------|
| [Microsoft Azure]({{< ref "providers#azure-provider" >}}) | Deploy and connect to Azure resources |
| [Amazon Web Services]({{< ref "providers#aws-provider" >}}) | Deploy and connect to AWS resources |

### External identity provider

You can optionally specify an external identity provider for your environment. This allows you to add to a Radius container an external identity such as an Azure user-assigned managed identity, and then specify role-based access control (RBAC) policies for that identity on Azure resources.

Supported identity providers:

- [Azure AD workload identity](https://azure.github.io/azure-workload-identity/docs/introduction.html)

Visit the Azure direct connection quickstart for more information. (coming soon)

## CLI commands

The following commands let you interact with Radius environments:

{{< tabs init list show delete switch >}}

{{% codetab %}}
`rad init` initializes a new Kubernetes environment:

```bash
rad init
```
{{% /codetab %}}

{{% codetab %}}
[rad env list]({{< ref rad_env_list >}}) lists all of the environments in your [workspace]({{< ref workspaces >}}):

```bash
rad env list
```
{{% /codetab %}}

{{% codetab %}}
[rad env show]({{< ref rad_env_show >}}) prints information on the default or specified environment:

```bash
rad env show
```
{{% /codetab %}}

{{% codetab %}}
[rad env delete]({{< ref rad_env_delete >}}) deletes the specified environment:

```bash
rad env delete -e myenv
```
{{% /codetab %}}

{{% codetab %}}
[rad env switch]({{< ref rad_env_switch >}}) switches the default environment:

```bash
rad env switch -e myenv
```
{{% /codetab %}}

{{< /tabs >}}

## Schema

Visit the [environment schema page]({{< ref environment-schema >}}) to learn more about environment properties and values.

{{< button page="environment-schema" text="Schema" >}}

## Example

The following example shows an environment configured with Kubernetes as the target runtime. The `default` namespace designates where to render application resources.

{{< rad file="snippets/environment.bicep" embed=true marker="//ENV" >}}

## How-to: Initialize a new environment

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