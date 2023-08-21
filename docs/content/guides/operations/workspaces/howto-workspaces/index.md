---
type: docs
title: "How-To: Use Radius workspaces"
linkTitle: "How-To: Workspaces"
description: "Learn how to handle multiple Radius platforms and environments with workspaces"
weight: 300
categories: "Overview"
---

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
