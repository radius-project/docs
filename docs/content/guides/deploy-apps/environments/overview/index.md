---
type: docs
title: "Overview: Radius Environments"
linkTitle: "Overview"
description: "Learn about Radius Environments and how to interact with them"
weight: 100
categories: "Overview"
tags: ["environments"]
---

## What is an environment?

Radius Environments are prepared "landing zones" for Radius Applications. Applications deployed to an environment will inherit the container runtime, configuration, Recipes, and other settings from the environment.

Environments are server-side resources that exist within the Radius control-plane. You can use the Radius API and [rad CLI](#cli-commands) to interact with your installation's environments.

## Configuration

The following configuration options are available for environments:

### Container runtime

Radius Environments can be configured with a container runtime, where Radius [containers]({{< ref "guides/author-apps/containers" >}}) will be deployed. Currently, only Kubernetes clusters are supported for container runtimes.

A Kubernetes namespace is specified on the environment to tell Radius where to render environment-scoped resources. For example, a shared database deployed to an environment will be deployed to the namespace specified on the environment. Application-scoped resources will be deployed into a new namespace for each application, in the format `<environment-namespace>-<application-name>`. For example, if an application named `myapp` is deployed to an environment with the namespace `default`, the application-scoped resources will be deployed to the namespace `default-myapp`.

### Cloud provider

You can optionally configure cloud providers allow you to deploy and connect to cloud resources across various cloud platforms. For example, you can use the Radius Azure provider to run your application's services in your Kubernetes cluster, while deploying Azure resources to a specified Azure subscription and resource group. More information on setting up a cloud provider can be found in the [providers]({{< ref providers >}}) section.

#### Supported cloud providers

- Microsoft Azure
- Amazon Web Services

### External identity provider

You can optionally specify an external identity provider for your environment. This allows you to add to a Radius container an external identity such as an Azure user-assigned managed identity, and then specify role-based access control (RBAC) policies for that identity on Azure resources.

Supported identity providers:

- [Azure AD workload identity](https://azure.github.io/azure-workload-identity/docs/introduction.html)

### Simulated environments

You can optionally designate an environment as "simulated". When enabled, a simulated environment will not deploy any output any resources or run any Recipes when an application is deployed. This is useful for dry runs or testing.

## CLI commands

The following commands let you interact with Radius Environments:

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

## Managing multiple environments

If you are working with multiple environments, you can use [workspaces]({{< ref "/guides/operations/workspaces/overview" >}}) to manage them. Workspaces allow you to switch between different sets of environments, and can be used to manage different environments for different projects.

{{< button page="/guides/operations/workspaces/overview" text="Workspaces" >}}
