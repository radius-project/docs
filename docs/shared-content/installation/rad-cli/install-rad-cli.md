The `rad` CLI manages your applications, resources, and environments. You can install it on your local machine with the following installation scripts:

{{< tabs "Linux/WSL" MacOS "Windows PowerShell" "GitHub Codespace" "Azure Cloud Shell" Binaries >}}

{{% codetab %}}
{{< latest >}}
```bash
wget -q "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" -O - | /bin/bash
```
{{< /latest >}}
{{< edge >}}
To install the latest edge release, first install the oras CLI: https://oras.land/docs/installation
Then, run the following command to install the rad CLI:
```bash
wget -q "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" -O - | /bin/bash -s edge
```
{{< /edge >}}
{{% /codetab %}}

{{% codetab %}}
{{< latest >}}
```bash
curl -fsSL "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" | /bin/bash
```
{{< /latest >}}
{{< edge >}}
To install the latest edge release, first install the oras CLI: https://oras.land/docs/installation
Then, run the following command to install the rad CLI:
```bash
curl -fsSL "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" | /bin/bash -s edge
```
{{< /edge >}}
{{% /codetab %}}

{{% codetab %}}
{{< latest >}}
Run the following in a PowerShell window:

```powershell
iwr -useb "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.ps1" | iex
```

You may need to refresh your $PATH environment variable to access `rad`:
```powershell
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")
```
{{< /latest >}}
{{< edge >}}
To install the latest edge release, first install the oras CLI: https://oras.land/docs/installation
Then, run the following in a PowerShell window to install the rad CLI:
```powershell
$script=iwr -useb "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.ps1"; $block=[ScriptBlock]::Create($script); invoke-command -ScriptBlock $block -ArgumentList edge
```
{{< /edge >}}
{{% /codetab %}}

{{% codetab %}}
Radius offers a **free** Codespace option for getting up and running with a Radius environment in seconds:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/radius-project/samples)

{{% /codetab %}}

{{% codetab %}}
[Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) is an interactive, authenticated, browser-accessible shell for managing Azure resources.

Azure Cloud Shell for bash doesn't have a sudo command, so users are unable to install Radius to the default `/usr/local/bin` installation path. To install the rad CLI to the home directory, run the following commands:

```bash
export RADIUS_INSTALL_DIR=./
wget -q "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" -O - | /bin/bash
```

You can now run the rad CLI with `./rad`.

PowerShell for Cloud Shell is currently not supported.
{{% /codetab %}}

{{% codetab %}}
Visit [Radius GitHub releases](https://github.com/radius-project/radius/releases) to select and download a specific version of the rad CLI.

{{% /codetab %}}

{{< /tabs >}}

> You may be prompted for your sudo password during installation, as the installer places the `rad` binary under `/usr/local/bin`. If you are unable to sudo you can install the rad CLI to another directory by setting the `RADIUS_INSTALL_DIR` environment variable with your intended install path. Make sure you add this to your path ([Unix](https://www.howtogeek.com/658904/how-to-add-a-directory-to-your-path-in-linux/), [Windows](https://windowsloop.com/how-to-add-to-windows-path/)) if you wish to reference it via `rad`, like in the docs.

Verify the rad CLI is installed correctly by running `rad version`. 

Example output:
```
RELEASE     VERSION     BICEP       COMMIT
{{< param chart_version >}}      {{< param version >}}        0.28.1     2e60bfb46de73ec5cc70485d53e67f8eaa914ba7
```