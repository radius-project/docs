---
type: docs
title: "Getting started"
linkTitle: "Getting started"
description: "How to get up and running with Project Radius tooling in just a few minutes"
weight: 10
no_list: true
---


## Install CLI

{{< tabs Windows MacOS "Linux/WSL" "Cloud Shell" Binaries >}}

{{% codetab %}}
(PowerShell)

```powershell
iwr -useb "https://get.radapp.dev/tools/rad/install.ps1" | iex
```
{{% /codetab %}}

{{% codetab %}}
```bash
curl -fsSL "https://get.radapp.dev/tools/rad/install.sh" | /bin/bash
```
{{% /codetab %}}

{{% codetab %}}
```bash
wget -q "https://get.radapp.dev/tools/rad/install.sh" -O - | /bin/bash
```
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

   - MacOS: https://get.radapp.dev/tools/rad/0.6/macos-x64/rad
   - Linux: https://get.radapp.dev/tools/rad/0.6/linux-x64/rad
   - Windows: https://get.radapp.dev/tools/rad/0.6/windows-x64/rad.exe

1. Ensure the user has permission to execute the binary and place it somewhere on your PATH so it can be invoked easily.
{{% /codetab %}}

{{< /tabs >}}

Verify the rad CLI is installed correctly by running `rad`. 


## Create a Radius environment

{{< tabs "Azure" "Kubernetes" >}}

{{% codetab %}}

Pre-requisites:
- [Az CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (version 2.25.0 or later)

_Note that you are responsible for any costs incurred in your subscription._

1. Use the `az` CLI to authenticate with Azure your Azure account:

   ```sh
   az login
   ```

1. To create a Radius environment, run the following in your terminal, then follow the on-screen instructions.

   ```sh
   rad env init azure -i
   ```

   **This will prompt you for several inputs and then create assets in your subscription (~5-10 mins).**

   For more info about what's being created as part of an environment, see [Azure environments]({{< ref azure-environments>}}).

1. Verify creation of your new environment:

   ```sh
   rad env list
   ```

{{% /codetab %}}

{{% codetab %}}
Pre-requisites:
- You have a Kubernetes cluster configured with a local `kubectl` context set as the default. (You can verify with `kubectl config current-context`.)

1. Create a Radius environment in the default Kubernetes namespace:

   ```sh
   rad env init kubernetes
   ```

   For more info about what's being created as part of an environment, see [Kubernetes environments]({{< ref kubernetes-environments >}}).

1. Verify creation of your new environment:

   ```sh
   rad env list
   ```
{{% /codetab %}}

{{< /tabs >}}




## Deploy an app 
TODO: Copy some repo and ..... to get started with the quickest possible. 

Btw, other ways to get started:
- quickstarts
- sample apps
- your own apps via (authoring link)


## Btw, do you use VSCode? 
If so, we have great tooling for you! 

Pre-requisites:
- [Visual Studio Code](https://code.visualstudio.com/)

### Setup  VSCode
Optionally install the Radius VSCode extensions for syntax highlighting, auto-completion, and linting. Not required to build apps with Radius. 



1. Download the latest extensions

  ```bash
   curl https://radiuspublic.blob.core.windows.net/tools/vscode/stable/rad-vscode-bicep.vsix --output rad-vscode-bicep.vsix
   curl https://radiuspublic.blob.core.windows.net/tools/vscode/stable/rad-vscode.vsix --output rad-vscode.vsix
   ```

2. Install the `.vsix` files:

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