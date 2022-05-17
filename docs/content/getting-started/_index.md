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

{{< tabs Windows MacOS "Linux/WSL" "Cloud Shell" Binaries >}}

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

Verify the rad CLI is installed correctly by running `rad`. 

## Create a Radius environment

A Radius environment is where you will deploy your applications. Easily deploy a new environment with the [`rad env init`]({{< ref rad_env_init >}}) command:

{{< tabs "Local" "Kubernetes" "Microsoft Azure" >}}

{{% codetab %}}
A local environment runs on your local machine, and makes it easy to run and deploy applications quickly.

### Pre-requisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [k3d](https://k3d.io/#installation)

```bash
rad env init dev -i
```

{{% /codetab %}}

{{% codetab %}}
### Pre-requisites

- Kubernetes cluster configured as the default `kubectl` context (verify with `kubectl config current-context`)


```sh
rad env init kubernetes
```
{{% /codetab %}}
{{% codetab %}}
### Pre-requisites

- [Az CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (version 2.25.0 or later)

_Note that you are responsible for any costs incurred in your subscription._

### Steps

1. Use the `az` CLI to authenticate with Azure your Azure account:

   ```sh
   az login
   ```

1. Create a new Azure environment:

   ```sh
   rad env init azure -i
   ```

   _This will prompt you for several inputs and then create assets in your subscription (~5-10 mins)._
{{% /codetab %}}

{{< /tabs >}}

## Install VS Code extension (optional)

Optionally install the Radius [Visual Studio Code](https://code.visualstudio.com/) extensions for syntax highlighting, auto-completion, and linting.

{{% alert title="Note" color="primary" %}}
While Project Radius is in preview two separate extensions are required, one for Bicep highlighting and one for interacting with Radius applications. In a future release, these will be combined into a single extension.
{{% /alert %}}

1. Download the latest extensions

   {{< tabs Links Terminal >}}

   {{% codetab %}}
   {{< button link="https://radiuspublic.blob.core.windows.net/tools/vscode/stable/rad-vscode-bicep.vsix" text="Download Bicep extension" >}}

   {{< button link="https://radiuspublic.blob.core.windows.net/tools/vscode/stable/rad-vscode.vsix" text="Download Radius extension" >}}

   {{% /codetab %}}

   {{% codetab %}}

   ```bash
   curl https://radiuspublic.blob.core.windows.net/tools/vscode/stable/rad-vscode-bicep.vsix --output rad-vscode-bicep.vsix
   curl https://radiuspublic.blob.core.windows.net/tools/vscode/stable/rad-vscode.vsix --output rad-vscode.vsix
   ```

   {{% /codetab %}}

   {{< /tabs >}}

1. Install the `.vsix` files:

   {{< tabs UI Terminal >}}

   {{% codetab %}}
   In VSCode, manually install the extension using the *Install from VSIX* command in the Extensions view command drop-down.

   <img src="./vsix-install.png" alt="Screenshot of installing a vsix extension" width=400>

   {{% /codetab %}}

   {{% codetab %}}
   You can also import this extension on the [command-line](https://code.visualstudio.com/docs/editor/extension-gallery#_install-from-a-vsix) with:

   ```bash
   code --install-extension rad-vscode-bicep.vsix
   code --install-extension rad-vscode.vsix
   ```

   {{% /codetab %}}

   {{< /tabs >}}

1. Disable the official Bicep extension if you have it installed. Do not install it if prompted, our custom extension needs to be responsible for handling `.bicep` files and you cannot have both extensions enabled at once.

1. If running on Windows Subsystem for Linux (WSL), make sure to install the extension in WSL as well:

   <img src="./wsl-extension.png" alt="Screenshot of installing a vsix extension in WSL" width=400>

<!-- TODO: add table of samples and tutorials 
(maybe a table like on this page https://docs.dapr.io/getting-started/quickstarts/ ? ) -->