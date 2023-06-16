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
Radius cloud providers allow you to deploy and connect to cloud resources across various cloud platforms. For example, you can use the Radius Azure provider to run your application's services in your Kubernetes cluster, while deploying Azure resources to a specified Azure subscription and resource group.

<img src="providers-overview.png" alt="Diagram of cloud resources getting forwarded to cloud platforms upon deployment" width="800px" >

#### Supported cloud providers

| Provider | Description |
|----------|-------------|
| [Microsoft Azure](#azure-provider) | Deploy and connect to Azure resources |
| [Amazon Web Services](#aws-provider) | Deploy and connect to AWS resources |

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

