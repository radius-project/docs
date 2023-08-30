---
type: docs
title: "Overview: Radius workspaces"
linkTitle: "Workspaces"
description: "Learn how to handle multiple Radius platforms and environments with workspaces"
weight: 200
categories: "Overview"
---

Workspaces allow you to manage multiple Radius platforms and environments using a local configuration file. You can easily define and switch between workspaces to deploy and manage applications across separate environments.

<img src=workspaces.png alt="Diagram showing a Radius configuration file mapping workspaces to Kubernetes clusters" width=800px />

## CLI commands

The following commands let you interact with Radius environments:

{{< tabs create list show delete switch >}}

{{% codetab %}}
[rad workspace init kubernetes]({{< ref rad_workspace_create >}}) creates a new workspace:

```bash
rad workspace init kubernetes
```
{{% /codetab %}}

{{% codetab %}}
[rad workspace list]({{< ref rad_workspace_list >}}) lists all of the workspaces in your configuration file:

```bash
rad workspacae list
```
{{% /codetab %}}

{{% codetab %}}
[rad workspace show]({{< ref rad_workspace_show >}}) prints information on the default or specified workspace:

```bash
rad workspace show
```
{{% /codetab %}}

{{% codetab %}}
[rad workspace delete]({{< ref rad_workspace_delete >}}) deletes the specified workspace:

```bash
rad workspace delete -w myenv
```
{{% /codetab %}}

{{% codetab %}}
[rad workspace switch]({{< ref rad_workspace_switch >}}) switches the default workspace:

```bash
rad env switch -e myenv
```
{{% /codetab %}}

{{< /tabs >}}

## Example

Your Radius configuration file contains workspace entries that point to a Radius platform and environment:

```yaml
workspaces:
  default: dev
  items:
    dev:
      connection:
        context: DevCluster
        kind: kubernetes
      environment: /planes/radius/local/resourcegroups/dev/providers/applications.core/environments/dev
      scope: /planes/radius/local/resourceGroups/dev
      providerConfig:
        azure:
          subscriptionid: DEV-SUBID
          resourcegroup: Dev
    prod:
      connection:
        context: ProdCluster
        kind: kubernetes
      environment: /planes/radius/local/resourcegroups/prod/providers/applications.core/environments/prod
      scope: /planes/radius/local/resourceGroups/prod
      providerConfig:
        azure:
          subscriptionid: PROD-SUBID
          resourcegroup: Prod
```

## Schema

Visit the [`config.yaml` reference docs]({{< ref config >}}) to learn about workspace definitions.

{{< button text="config.yaml Schema" page="config" >}}

## How-to: Use workspaces to switch between environments

When you have multiple environments initialized for different purposes workspaces enable you to switch between different environments easily. You can create separate workspaces and switch between them as you are working through your deployment lifecycle.

1. Install the Radius control plane on kubernetes cluster
   ```sh
   rad install kubernetes
   ```
1. Create a resource group named `myworkspace` using [`rad group create`]({{< ref rad_group_create >}}):
   ```sh
   rad group create myworkspace
   ```
1. Create an environment named `myworkspace` using [`rad env create`]({{< ref rad_env_create >}}):
   ```sh
   rad env create myworkspace
   ```
1. Create a workspace named `myworkspace` using [`rad workspace create`]({{< ref rad_workspace_create >}}):
    ```sh 
    rad workspace create kubernetes myworkspace --group myworkspace --environment myworkspace
    ```
    Radius writes the workspace details to your local configuration file (`~/.rad/config.yaml` on Linux and macOS, `%USERPROFILE%\.rad\config.yaml` on Windows).
1. Create another resource group named `yourworkspace` using [`rad group create`]({{< ref rad_group_create >}}):
   ```sh
   rad group create yourworkspace
   ```
1. Create an environment named `yourworkspace` using [`rad env create`]({{< ref rad_env_create >}}):
   ```sh
   rad env create yourworkspace
   ```
1. Create a workspace named `yourworkspace` using [`rad workspace create`]({{< ref rad_workspace_create >}}):
    ```sh 
    rad workspace create kubernetes yourworkspace --group yourworkspace --environment yourworkspace
    ```
1. Verify your `config.yaml` file. It should show both `myworkspace` and `yourworkspace` workspaces, with your environments:
    ```yaml
    workspaces:
    default: yourworkspace
    items:
      yourworkspace:
        connection:
          context: mycluster
          kind: kubernetes
        environment: /planes/radius/local/resourcegroups/yourworkspace
        /providers/applications.core/environments/yourworkspace
        scope: /planes/radius/local/resourceGroups/yourworkspace
      myworkspace:
        connection:
          context: mycluster
          kind: kubernetes
        environment: /planes/radius/local/resourcegroups/myworkspace
        /providers/applications.core/environments/myworkspace
        scope: /planes/radius/local/resourceGroups/myworkspace
    ```
1. You can now deploy applications to both myworkspace and yourworkspace using [`rad deploy`]({{< ref rad_deploy >}}), specifying the `-w` flag.