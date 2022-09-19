---
type: docs
title: "Radius environments"
linkTitle: "Environments"
description: "Learn about Radius environments and how to interact with them"
weight: 20
---

Radius environments are prepared "landing zones" for Radius applications. Applications deployed to an environment will inherit the container runtime, configuration, and other settings from the environment. Stay tuned for additional environment capabilities coming soon.

## Configuration

The following configuration options are available for environments:

### Container runtime

Radius environments can be configured with a container runtime, where Radius [containers]({{< ref container >}}) will be run, along with [gateways and routes]({{< ref networking >}}).

A Kubernetes namespace is specied on the environment to tell Radius where to render application resources at deploy time.

<img src=environments.png alt="Diagram showing a Radius environment mapping to a Kubernetes cluster and namespace" width=800px />

## Schema

Visit the [environment schema page]({{< ref environment-schema >}}) to learn more about environment properties and values.

{{< button page="environment-schema" text="Schema" >}}

## CLI commands

The following commands let you interact with Radius environments:

{{< tabs init list show delete switch >}}

{{% codetab %}}
[rad env init kubernetes]({{< ref rad_env_init_kubernetes >}}) initializes a new Kubernetes environment:

```bash
rad env init kubernetes
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

## Example

The following example shows an environment configured with Kubernetes as the target runtime. The `default` namespace designates where to render application resources.

{{< rad file="snippets/environment.bicep" embed=true marker="//ENV" >}}

## How-to: Initialize a new environment

1. Begin by deploying a compatible [Kubernetes cluster]({{< ref kubernetes >}})
> Visit the [Kubernetes platform docs]({{< ref kubernetes >}}) for a list of supported clusters and specific cluster requirements.

1. Ensure your target kubectl context is set as the default:
   ```bash
   kubectl config current-context
   ```
1. Initialize a new environment with [`rad env init kubernetes` command]({{< ref rad_env_init_Kubernetes >}}):
   ```bash
   rad env init kubernetes -i
   ```
1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Azure provider** (optional) - Allows you to [deploy and manage Azure resources]({{<ref providers>}})
   - **Environment name** - The name of the environment to create
1. Let the rad CLI run the following tasks:
   1. **Install the control plane** - Radius installs the [control plane services]({{< ref architecture >}}) in the `radius-system` namespace
   1. **Create the environment** - An environment resource is created in the Radius control plane. It maps to a Kubernetes namespace.
   1. **Add the Azure Cloud Provider** - The Azure cloud provider configuration is saved in the Radius control plane
   1. **Create a workspace** - [Workspaces]({{< ref workspaces >}}) are local pointers to a cluster running Radius, and an environment. Workspaces are saved to the Radius config file (`~/.rad/config.yaml` on Linux and macOS, `%USERPROFILE%\.rad\config.yaml` on Windows)
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
   dapr-dashboard            1/1     1            1           35s
   dapr-sidecar-injector     1/1     1            1           35s
   dapr-sentry               1/1     1            1           35s
   dapr-operator             1/1     1            1           35s
   ```

   You can also use [`rad env list`]({{< ref rad_env_list.md >}}) to see if the created environment gets listed:
   
   ```bash
   rad env list
   ```


