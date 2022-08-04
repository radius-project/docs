---
type: docs
title: "Getting started"
linkTitle: "Getting started"
description: "How to get up and running with Project Radius tooling in just a few minutes"
weight: 20
no_list: true
---

## Install `rad` CLI

The `rad` CLI manages your applications, resources, and environments. Begin by installing it on your machine:

{{< tabs Windows MacOS "Linux/WSL" "Codespace/Dev Container" "Cloud Shell" Binaries >}}

{{% codetab %}}

```powershell
iwr -useb "https://get.radapp.dev/tools/rad/install.ps1" | iex
```

{{< edge >}}
To install the latest edge version:

```powershell
$script=iwr -useb  https://radiuspublic.blob.core.windows.net/tools/rad/install.ps1; $block=[ScriptBlock]::Create($script); invoke-command -ScriptBlock $block -ArgumentList edge
```
{{< /edge >}}
{{% /codetab %}}

{{% codetab %}}
```bash
curl -fsSL "https://get.radapp.dev/tools/rad/install.sh" | /bin/bash
```

{{< edge >}}
To install the latest edge version:

```bash
curl -fsSL "https://radiuspublic.blob.core.windows.net/tools/rad/install.sh" | /bin/bash -s edge
```
{{< /edge >}}
{{% /codetab %}}

{{% codetab %}}
```bash
wget -q "https://get.radapp.dev/tools/rad/install.sh" -O - | /bin/bash
```

{{< edge >}}
To install the latest edge version:

```bash
wget -q "https://radiuspublic.blob.core.windows.net/tools/rad/install.sh" -O - | /bin/bash -s edge
```
{{< /edge >}}
{{% /codetab %}}

{{% codetab %}}
Do you prefer to test out Radius in a fast and easy to use virtual environment? Check out the [Radius samples repo](https://github.com/project-radius/samples) to test out the sample applications on a pre-configured [GitHub Codespaces](https://github.com/features/codespaces) container.

You can also run a [dev container](https://code.visualstudio.com/docs/remote/containers) on your local machine within Docker.

Visit the [GitHub docs]({{< ref github >}}) if you need access to the organization

This container image is automatically configured with the rad CLI, extension, and a running environment. You can skip down to the [Learn Radius](#learn-radius) section to get started.
{{% /codetab %}}

{{% codetab %}}
[Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) is an interactive, authenticated, browser-accessible shell for managing Azure resources.

Azure Cloud Shell for bash doesn't have a sudo command, so users are unable to install Radius to the default `/usr/local/bin` installation path. To install the rad CLI to the home directory, run the following commands:

```bash
export RADIUS_INSTALL_DIR=./
wget -q "https://get.radapp.dev/tools/rad/install.sh" -O - | /bin/bash
```

You can now run the rad CLI with `./rad`.

PowerShell for Cloud Shell is currently not supported.
{{% /codetab %}}

{{% codetab %}}
1. Download the `rad` CLI from one of these URLs:

   - MacOS: https://get.radapp.dev/tools/rad/edge/macos-x64/rad
   - Linux: https://get.radapp.dev/tools/rad/edge/linux-x64/rad
   - Windows: https://get.radapp.dev/tools/rad/edge/windows-x64/rad.exe

1. Ensure the user has permission to execute the binary and place it somewhere on your PATH so it can be invoked easily.

{{< edge >}}
### Edge releases

- MacOS: https://radiuspublic.blob.core.windows.net/tools/rad/edge/macos-x64/rad
- Linux: https://radiuspublic.blob.core.windows.net/tools/rad/edge/linux-x64/rad
- Windows: https://radiuspublic.blob.core.windows.net/tools/rad/edge/windows-x64/rad.exe
{{< /edge >}}
{{% /codetab %}}

{{< /tabs >}}

> You may be prompted for your sudo password during installation. If you are unable to sudo you can install the rad CLI to another directory by setting the `RADIUS_INSTALL_DIR` environment variable with your intended install path.

Verify the rad CLI is installed correctly by running `rad`. 

## Learn Radius

| Guides | Description  |
| --- | ----------- |
| [Tutorial]({{< ref tutorial >}}) | Walk through an in-depth example to learn more about how to work with Radius concepts |
| [Quickstarts]({{< ref quickstarts >}}) | Learn about Project Radius topics via quickstart guides, complete with code samples |
| [Reference Applications]({{< ref reference-apps >}}) | See how full applications are modeled in Project Radius |
| [Supported Languages]({{< ref supported-languages >}}) | Learn how to model apps using various IaC tools |
