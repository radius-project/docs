---
type: docs
title: "Overview: rad CLI"
linkTitle: "Overview"
description: "Learn about the rad CLI and how to interact with Radius from your local machine"
weight: 100
categories: "Overview"
tags: ["rad CLI"]
---

The rad Command Line Interface (CLI) allows you to interact with Radius from your local machine. It is the primary way to interact with Radius and is used to create, deploy, and manage your applications, environments, and resources.

```bash
$ rad
Radius CLI

Usage:
  rad [command]

Available Commands:
  application Manage Radius Applications
  bicep       Manage bicep compiler
  completion  Generates shell completion scripts
  credential  Manage cloud provider credential for a Radius installation.
  debug-logs  Capture logs from Radius control plane for debugging and diagnostics.
  deploy      Deploy a template
  env         Manage Radius Environments
  group       Manage resource groups
  help        Help about any command
  init        Initialize Radius
  install     Installs Radius for a given platform
  recipe      Manage recipes
  resource    Manage resources
  run         Run an application
  uninstall   Uninstall Radius for a specific platform
  version     Prints the versions of the rad cli
  workspace   Manage workspaces
```

## Installation

The rad CLI is distributed as a single binary that can be installed on Linux, macOS, and Windows. Visit the [installation guide]({{< ref howto-rad-cli >}}) to learn how to install the rad CLI.

{{< button text="Install rad CLI" page="howto-rad-cli" >}}

### Binary location

{{< tabs "macOS/Linux/WSL" "Windows" >}}

{{% codetab %}}
By default, the rad CLI installation script installs the rad CLI to `/usr/local/bin/rad`

If you would like to install the rad CLI to a different path, you can specify the path with the `RADIUS_INSTALL_DIR` environment variable:

```bash
# Install to home directory
export RADIUS_INSTALL_DIR=~/
```

{{% /codetab %}}

{{% codetab %}}
By default, the rad CLI installation script installs the rad CLI to `%LOCALAPPDATA%\radius\rad.exe`

{{% /codetab %}}

{{< /tabs >}}

### Configuration location

The rad CLI stores workspaces, the rad-Bicep compiler, and other configuration under the `rad` directory.

{{< tabs "macOS/Linux/WSL" "Windows" >}}

{{% codetab %}}
The rad CLI stores configuration under `~/.rad`
{{% /codetab %}}

{{% codetab %}}
The rad CLI stores configuration under `%USERPROFILE%\rad`
{{% /codetab %}}

{{< /tabs >}}


## Reference documentation

Visit the [reference documentation]({{< ref "/reference/cli" >}}) to learn more about the rad CLI and its commands.

{{< button text="Reference docs" page="/reference/cli" >}}