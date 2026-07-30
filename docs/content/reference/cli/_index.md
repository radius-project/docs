---
type: docs
title: "Radius CLI reference"
linkTitle: "Radius CLI"
description: "Reference documentation for the Radius CLI"
weight: 100
aliases:
  - /reference/cli/config/
---

## Introduction

The Radius CLI (`rad`) is the primary tool for interacting with Radius from your terminal. This section contains reference material for each `rad` command as well as the [local workspace configuration file](#local-workspace-config), which stores the settings that connect the CLI to your Radius control plane.

All of the command reference material here is also available directly from your terminal by running `rad <command> --help`.

## Local workspace config

Radius stores [Workspaces]({{< ref "/management/workspaces" >}}) in a local `config.yaml` file that selects the control plane, Resource Group, and Environment that `rad` commands target:

- **macOS/Linux:** `~/.rad/config.yaml`
- **Windows:** `%USERPROFILE%\.rad\config.yaml`

```yaml
workspaces:
  default: dev            # Workspace used when --workspace is omitted
  items:
    dev:
      connection:
        kind: kubernetes
        context: DevCluster   # Kubernetes context used to reach the control plane
      environment: /planes/radius/local/resourceGroups/dev/providers/Radius.Core/environments/dev
      scope: /planes/radius/local/resourceGroups/dev   # Default Resource Group
```

| Key | Description |
|-----|-------------|
| `default` | Name of the Workspace used when `--workspace` is not passed. |
| `items.<name>.connection.kind` | Connection type. Use `kubernetes` for a Kubernetes-hosted control plane. |
| `items.<name>.connection.context` | Kubernetes context used to reach the control plane. |
| `items.<name>.environment` | Default Environment resource ID for the Workspace. |
| `items.<name>.scope` | Default Resource Group scope for `rad` commands. |
