---
type: docs
title: "How-To: Install the rad CLI"
linkTitle: "How-To: rad CLI"
description: "Learn how to install the rad CLI on your local machine"
weight: 100
categories: "How-To"
tags: ["rad CLI", "Bicep"]
---

The `rad` CLI manages your applications, resources, and environments. You can install it on your local machine with the following installation scripts:

{{< tabs MacOS "Linux/WSL" "Windows PowerShell" "Cloud Shell" Binaries >}}

{{% codetab %}}
{{< latest >}}
```bash
curl -fsSL "https://get.radapp.dev/tools/rad/install.sh" | /bin/bash
```
{{< /latest >}}
{{< edge >}}
To install the latest edge version:

```bash
curl -fsSL "https://radiuspublic.blob.core.windows.net/tools/rad/install.sh" | /bin/bash -s edge
```
{{< /edge >}}
{{% /codetab %}}

{{% codetab %}}
{{< latest >}}
```bash
wget -q "https://get.radapp.dev/tools/rad/install.sh" -O - | /bin/bash
```
{{< /latest >}}
{{< edge >}}
To install the latest edge version:

```bash
wget -q "https://radiuspublic.blob.core.windows.net/tools/rad/install.sh" -O - | /bin/bash -s edge
```
{{< /edge >}}
{{% /codetab %}}

{{% codetab %}}
{{< latest >}}
Run the following in a PowerShell window:

```powershell
iwr -useb "https://get.radapp.dev/tools/rad/install.ps1" | iex
```

You may need to refresh your $PATH environment variable to access `rad`:
```powershell
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")
```
{{< /latest >}}
{{< edge >}}
To install the latest edge version:

```powershell
$script=iwr -useb  https://radiuspublic.blob.core.windows.net/tools/rad/install.ps1; $block=[ScriptBlock]::Create($script); invoke-command -ScriptBlock $block -ArgumentList edge
```
{{< /edge >}}
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
   - MacOS x64: https://get.radapp.dev/tools/rad/{{< param version >}}/macos-x64/rad
   - MacOS arm64: https://get.radapp.dev/tools/rad/{{< param version >}}/macos-arm64/rad
   - Linux x64: https://get.radapp.dev/tools/rad/{{< param version >}}/linux-x64/rad
   - Windows x64: https://get.radapp.dev/tools/rad/{{< param version >}}/windows-x64/rad.exe
1. Ensure the user has permission to execute the binary and place it somewhere on your PATH so it can be invoked easily.
{{% /codetab %}}

{{< /tabs >}}

> You may be prompted for your sudo password during installation, as the installer places the `rad` binary under `/usr/local/bin`. If you are unable to sudo you can install the rad CLI to another directory by setting the `RADIUS_INSTALL_DIR` environment variable with your intended install path. Make sure you add this to your path ([Unix](https://www.howtogeek.com/658904/how-to-add-a-directory-to-your-path-in-linux/), [Windows](https://windowsloop.com/how-to-add-to-windows-path/)) if you wish to reference it via `rad`, like in the docs.

Verify the rad CLI is installed correctly by running `rad`.

## Learn Radius

| Guides | Description  |
| --- | ----------- |
| [Run your first app]({{< ref getting-started >}}) | Take a tour of Radius by running your first app |
| [Tutorials]({{< ref tutorials >}}) | Learn about Radius via guided tutorial, complete with code samples |
