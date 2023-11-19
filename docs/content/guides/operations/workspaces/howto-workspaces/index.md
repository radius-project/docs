---
type: docs
title: "How-To: Use Radius workspaces"
linkTitle: "Use Workspaces"
description: "Learn how to handle multiple Radius platforms and environments with workspaces"
weight: 300
categories: "How-To"
---

## Pre-requisites

- [Setup a supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})

## How-to: Use workspaces to switch between environments

When you have multiple environments initialized for different purposes workspaces enable you to switch between different environments easily. You can create separate workspaces and switch between them as you are working through your deployment lifecycle.

1. Install the Radius control plane on kubernetes cluster
   ```sh
   rad install kubernetes
   ```
2. Create a resource group named `mygroup` using [`rad group create`]({{< ref rad_group_create >}}):
   ```sh
   rad group create mygroup
   ```
3. Create an environment named `myenvironment` using [`rad env create`]({{< ref rad_env_create >}}):
   ```sh
   rad env create myenvironment
   ```
4. Create a workspace named `myworkspace` using [`rad workspace create`]({{< ref rad_workspace_create >}}):
    ```sh
    rad workspace create kubernetes myworkspace --group mygroup --environment myenvironment
    ```
    Radius writes the workspace details to your local configuration file (`~/.rad/config.yaml` on Linux and macOS, `%USERPROFILE%\.rad\config.yaml` on Windows).
5. Create another resource group named `yourgroup` using [`rad group create`]({{< ref rad_group_create >}}):
   ```sh
   rad group create yourgroup
   ```
6. Create an environment named `yourenvironment` using [`rad env create`]({{< ref rad_env_create >}}):
   ```sh
   rad env create yourenvironment
   ```
7. Create a workspace named `yourworkspace` using [`rad workspace create`]({{< ref rad_workspace_create >}}):
    ```sh
    rad workspace create kubernetes yourworkspace --group yourgroup --environment yourenvironment
    ```
8. Verify your `config.yaml` file. It should show both `myworkspace` and `yourworkspace` workspaces, with your environments:
    ```yaml
    workspaces:
    default: yourworkspace
    items:
      yourworkspace:
        connection:
          context: mycluster
          kind: kubernetes
        environment: /planes/radius/local/resourcegroups/yourgroup/providers/applications.core/environments/yourenvironment
        scope: /planes/radius/local/resourceGroups/yourgroup
      myworkspace:
        connection:
          context: mycluster
          kind: kubernetes
        environment: /planes/radius/local/resourcegroups/mygroup/providers/applications.core/environments/myenvironment
        scope: /planes/radius/local/resourceGroups/mygroup
    ```
9. You can now deploy applications to both myworkspace and yourworkspace using [`rad deploy`]({{< ref rad_deploy >}}), specifying the `-w` flag.
