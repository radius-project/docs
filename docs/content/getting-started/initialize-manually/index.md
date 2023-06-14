---
type: docs
title: "Initialize a Radius Environment"
linkTitle: "Initialize a Radius Environment"
description: "Learn how to initialize a Radius Environment"
weight: 100
categories: "How-To"
tags: ["rad CLI"]
---

## Prerequisite

- [`rad` CLI]({{< ref install >}})

## Initialize a Radius Environment

Radius runs inside [Kubernetes]({{< ref kubernetes-platform >}}). However you run Kubernetes, get a cluster ready.

Radius environments are a prepared landing zone for applications. For more information visit [Radius Environment]{{< ref environments-concept >}}.

{{< tabs "Granular Setup" Init >}}

{{% codetab %}}

1. Install Radius onto a Kubernetes cluster:

    Use the following command to target your desired Kubernetes cluster.

    For a list of all the supported command options visit [rad install kubernetes]({{< ref rad_install_kubernetes >}})

    ```bash
    rad install kubernetes --chart <user-chart> --tag <user-tag> --set <user-set>
    ```


2. Create a Radius Workspace:

    Workspaces allow you to manage multiple Radius platforms and environments using a local configuration file.

    You can easily define and switch between workspaces to deploy and manage applications across local, test, and production environments.

    Create a workspace with your desired name and your desired Kubernetes context. For a more detailed dive into the command visit [`rad workspace create`]({{< ref rad_workspace_create >}}).

    ```bash
    rad workspace create kubernetes <user-workspace> --context <user-kubernetes-context>
    ```

3. Create a new Radius resource group:

    Radius resource groups are used to organize Radius resources, such as applications, environments, links, and routes. For more information visit [Radius resource groups]({{< ref groups >}}).

    For a dive into the command visit [`rad group create`]({{< ref rad_group_create >}})

    ```bash
    rad group create <user-radius-resource-group>
    ```

4. Set your Radius resource group:

    ```bash
    rad group switch <user-radius-resource-group>
    ```

    For a dive into the command visit [`rad group switch`]({{< ref rad_group_switch >}})

5. Create your Radius Environment and pass it your Kubernetes namespace:

    ```bash
    rad env create <user-radius-environment> --namespace <kubernetes-namespace>
    ```

    For a dive into the command visit [`rad env create`]({{< ref rad_env_create >}})

6. Set your Radius Environment:

    ```bash
    rad env switch kind-radius
    ```

    For a dive into the command visit [`rad env switch`]({{< ref rad_env_switch >}}).

{{% /codetab %}}

{{% codetab %}}

To follow an interactive Radius setup run:

```bash
rad init
```

Follow the prompts to install the [control plane services]({{< ref architecture >}}), create an [environment resource]({{< ref environments-resource >}}), and create a [local workspace]({{< ref workspaces >}}). 

{{% /codetab %}}

{{< /tabs >}}

## Configure cloud providers

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