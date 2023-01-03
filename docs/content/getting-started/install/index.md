---
type: docs
title: "Install Project Radius"
linkTitle: "Install Radius"
description: "Learn how to install the Radius tools on your local machine"
weight: 100
---

{{< alert title="Get started in seconds with a Codespace" color="primary" >}}
Use a free [GitHub Codespace](https://github.com/features/codespaces) to test out the sample applications and build your own in a pre-configured container complete with the rad CLI, Bicep extension, and a pre-deployed environment. Once launched, you can skip directly to [the tutorial]({{< ref tutorial >}}).

<a class="btn btn-primary" href="https://aka.ms/ProjectRadius/Codespace" role="button" target="_blank">Launch a new Codespace</a>

_Visit the [GitHub docs]({{< ref github >}}) if you need access to the organization._
{{< /alert >}}

## Install `rad` CLI

The `rad` CLI manages your applications, resources, and environments. Begin by installing it on your machine:

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
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
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
{{< latest >}}
1. Download the `rad` CLI from one of these URLs:
   - MacOS: https://get.radapp.dev/tools/rad/0.16/macos-x64/rad
   - Linux: https://get.radapp.dev/tools/rad/0.16/linux-x64/rad
   - Windows: https://get.radapp.dev/tools/rad/0.16/windows-x64/rad.exe
1. Ensure the user has permission to execute the binary and place it somewhere on your PATH so it can be invoked easily.
{{< /latest >}}
{{< edge >}}
1. Download the `rad` CLI from one of these URLs:
   - MacOS: https://radiuspublic.blob.core.windows.net/tools/rad/edge/macos-x64/rad
   - Linux: https://radiuspublic.blob.core.windows.net/tools/rad/edge/linux-x64/rad
   - Windows: https://radiuspublic.blob.core.windows.net/tools/rad/edge/windows-x64/rad.exe
1. Ensure the user has permission to execute the binary and place it somewhere on your PATH so it can be invoked easily.
{{< /edge >}}
{{% /codetab %}}

{{< /tabs >}}

> You may be prompted for your sudo password during installation, as the installer places the `rad` binary under `/usr/local/bin`. If you are unable to sudo you can install the rad CLI to another directory by setting the `RADIUS_INSTALL_DIR` environment variable with your intended install path.

Verify the rad CLI is installed correctly by running `rad`.

## Setup VS Code

Visual Studio Code offers the best authoring experience for Project Radius and Bicep. Download and install the Radius Bicep extension to easily author and validate Bicep templates:

1. Download the latest extensions

   {{< tabs Links Terminal >}}

   {{% codetab %}}
   {{< button link="https://get.radapp.dev/tools/vscode-extensibility/stable/rad-vscode-bicep.vsix" text="Download Bicep extension" >}}

   {{< edge >}}
   {{< button link="https://get.radapp.dev/tools/vscode-extensibility/edge/rad-vscode-bicep.vsix" text="Download Bicep extension (edge)" >}}
   {{< /edge >}}
   {{% /codetab %}}

   {{% codetab %}}

   Stable Version

   ```bash
   curl https://get.radapp.dev/tools/vscode/stable/rad-vscode-bicep.vsix --output rad-vscode-bicep.vsix
   ```

   Edge Version

   ```bash
   curl https://get.radapp.dev/tools/vscode-extensibility/edge/rad-vscode-bicep.vsix --output rad-vscode-bicep.vsix
   ```

   {{% /codetab %}}

   {{< /tabs >}}

2. Install the `.vsix` file:

   {{< tabs UI Terminal >}}

   {{% codetab %}}
   In VSCode, manually install the extension using the *Install from VSIX* command in the Extensions view command drop-down.

   <img src="./vsix-install.png" alt="Screenshot of installing a vsix extension" width=400>

   {{% /codetab %}}

   {{% codetab %}}
   You can also import this extension on the [command-line](https://code.visualstudio.com/docs/editor/extension-gallery#_install-from-a-vsix) with:

   ```bash
   code --install-extension rad-vscode-bicep.vsix
   ```

   If you're on macOS, make sure to [setup the `code` alias](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line).

   {{% /codetab %}}

   {{< /tabs >}}

3. **Disable the official Bicep extension** if you have it installed. Do not install it if prompted, our custom extension needs to be responsible for handling `.bicep` files and you cannot have both extensions enabled at once.

4. If running on Windows Subsystem for Linux (WSL), make sure to install the extension in WSL as well:

   <img src="./wsl-extension.png" alt="Screenshot of installing a vsix extension in WSL" width=400>

## Learn Radius

| Guides | Description  |
| --- | ----------- |
| [Tutorial]({{< ref tutorial >}}) | Walk through an in-depth example to learn more about how to work with Radius concepts |
| [Quickstarts]({{< ref quickstarts >}}) | Learn about Project Radius topics via quickstart guides, complete with code samples |
| [Reference Applications]({{< ref reference-apps >}}) | See how full applications are modeled in Project Radius |
| [Supported Languages]({{< ref supported-languages >}}) | Learn how to model apps using various IaC tools |
