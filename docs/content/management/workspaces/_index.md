---
type: docs
title: "How to manage Workspaces"
linkTitle: "Manage Workspaces"
description: "Use Workspaces to connect the Radius CLI to a control plane, Resource Group, and Environment"
weight: 300
aliases:
  - /guides/workspaces/
  - /guides/installation/workspaces/
  - /guides/environments/workspaces/howto-workspaces/
  - /guides/environments/workspaces/overview/
---

A [Workspace]({{< ref "/reference/cli#local-workspace-config" >}}) is a named shortcut that connects the Radius CLI to a specific Radius control plane, selecting the `kubectl` context used to reach it along with the [Radius Resource Group]({{< ref "concepts#platform-engineer-components" >}}) and [Environment]({{< ref "concepts/environments" >}}) that `rad` commands target.

Workspaces are optional, but they save you from specifying the Resource Group and Environment on every `rad` command. When you install Radius with `rad initialize`, a Workspace named `default` is configured automatically, targeting the `default` Resource Group and `default` Environment. Most commands operate against the current Workspace, and you can switch between Workspaces or target a specific Workspace on a single command.

This guide explains how to create, inspect, select, replace, and delete Workspaces. For the configuration file format and storage location, see the [local Workspace configuration reference]({{< ref "/reference/cli#local-workspace-config" >}}).

## Before you begin

Before creating a Workspace, verify that:

- The [Radius control plane]({{< ref "/installation/control-plane" >}}) is installed and reachable through a context in your kubeconfig.
- The target [Resource Group]({{< ref "/management/groups" >}}) and [Environment]({{< ref "/management/environments" >}}) already exist on that control plane.

## Step 1: Create a Workspace

Use [`rad workspace create`]({{< ref rad_workspace_create >}}) to save a Kubernetes context, Resource Group, and Environment as a named Workspace:

<!-- TODO: Remove the `--preview` flag from `rad workspace create` below once it is no longer required. -->
```bash
rad workspace create kubernetes my-workspace \
  --context my-context \
  --group my-group \
  --environment my-environment \
  --preview
```

The `--context` flag selects the Kubernetes context used to reach the Radius control plane. The `--group` and `--environment` flags set the default Resource Group and Environment for commands using the Workspace. Omit both defaults to select only the control plane, or omit `--environment` to select the control plane and Resource Group without a default Environment.

Most `rad` commands do not accept a Kubernetes context directly. To run commands against a specific context without changing the active `kubectl` context, create a Workspace for that context and pass its name through `--workspace`.

Creating a Workspace makes it the current Workspace.

## Step 2: List and inspect Workspaces

Use [`rad workspace list`]({{< ref rad_workspace_list >}}) to display the saved Workspaces and identify the current one:

```bash
rad workspace list
```

Inspect the current Workspace or a named Workspace with [`rad workspace show`]({{< ref rad_workspace_show >}}):

```bash
rad workspace show
rad workspace show --workspace my-workspace
```

## Step 3: Switch the current Workspace

The current Workspace is the default target for `rad` commands. Use [`rad workspace switch`]({{< ref rad_workspace_switch >}}) to select another Workspace:

```bash
rad workspace switch my-workspace
```

Confirm the selection with `rad workspace show`. Subsequent commands use the selected control plane, Resource Group, and Environment unless the command overrides them.

## Step 4: Target a Workspace for one command

To use a different Workspace without changing the current one, pass `--workspace` (or `-w`) to the command:

```bash
rad deploy ./app.bicep --workspace my-workspace
```

This selects the Workspace's control plane, Resource Group, and Environment for that command only.

## Step 5: Replace a Workspace

To change a Workspace's context, Resource Group, or Environment, rerun `rad workspace create` with the same name and `--force`:

<!-- TODO: Remove the `--preview` flag from `rad workspace create` below once it is no longer required. -->
```bash
rad workspace create kubernetes my-workspace \
  --context another-context \
  --group another-group \
  --environment another-environment \
  --force \
  --preview
```

The replacement becomes the current Workspace. Specify every value the updated Workspace should retain.

## Step 6: Delete a Workspace

Delete a saved target with [`rad workspace delete`]({{< ref rad_workspace_delete >}}):

```bash
rad workspace delete my-workspace
```

Deleting a Workspace removes only its local configuration. It does not delete the Radius control plane, Resource Group, Environment, or deployed resources. Use `--yes` to skip the confirmation prompt.
