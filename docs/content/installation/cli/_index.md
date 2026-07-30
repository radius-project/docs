---
type: docs
title: "How to install the Radius CLI"
linkTitle: "Radius CLI"
description: "Learn how to install the Radius CLI and customize the installation directory"
weight: 100
aliases:
  - /guides/installation/cli/
  - /guides/installation/rad-cli/
  - /guides/installation/rad-cli/overview/
  - /guides/installation/rad-cli/howto-rad-cli/
---

The Radius command-line interface (`rad`) is the primary way to interact with Radius from your local machine. It is used to install the Radius control plane, create and manage Environments and Resource Groups, and deploy and manage Applications.

Because Radius uses [Bicep](https://github.com/Azure/bicep) to define Applications and resources, the Bicep CLI is installed when the Radius CLI is installed. Radius uses the Bicep CLI to compile Bicep code into deployable JSON.

Visit the [reference documentation]({{< ref "/reference/cli" >}}) to learn more about the Radius CLI and its commands.

## Install the Radius CLI

The Radius CLI is distributed as a single binary that can be installed on Linux, macOS, and Windows.

{{< read file="/shared-content/installation/rad-cli/install-rad-cli.md" >}}

#### Optionally specify the installation directory

{{< tabs "Linux and macOS" "Windows" >}}

{{% codetab %}}
By default it installs the Radius CLI to a user-writable location:

- When run as a normal user: `$HOME/.local/bin/rad`
- When run as `root`: `/usr/local/bin/rad`

To install to a different path, set the `INSTALL_DIR` environment variable before running the script:

```bash
# Install to your home directory
export INSTALL_DIR=~/.local/bin
```

If the install directory is not on your `PATH`, the script prints the command to add it.
{{% /codetab %}}

{{% codetab %}}
By default, the installation script installs the Radius CLI to `%LOCALAPPDATA%\radius\rad.exe`.

To install to a different path, set the `INSTALL_DIR` environment variable before running the script:

```powershell
# Install to a custom directory
$env:INSTALL_DIR = "$HOME\bin"
```

If you installed the CLI with WinGet, the install location is managed by WinGet and added to your `PATH` automatically; the `INSTALL_DIR` variable does not apply.
{{% /codetab %}}

{{< /tabs >}}

Verify the installation by running `rad version`.

## Next steps

Once the Radius CLI has been installed, install the Radius control plane.

{{< button text="Next step: How to install the Radius control plane" page="installation/control-plane" >}}
