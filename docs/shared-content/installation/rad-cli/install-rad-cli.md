Install the Radius CLI on your workstation with the appropriate installation script:

{{< tabs "Linux/WSL" MacOS "Windows PowerShell" "GitHub Codespace" "Azure Cloud Shell" Binaries >}}

{{% codetab %}}
{{< latest >}}

```bash
wget -q "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" -O - | /bin/bash
```

{{< /latest >}}
{{< edge >}}
To install the latest edge release, first install  [ORAS](https://oras.land/docs/installation). Then, run the following command to install the Radius CLI:

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
To install the latest edge release, first install [ORAS](https://oras.land/docs/installation). Then, run the following command to install the Radius CLI:

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
To install the latest edge release, first install [ORAS](https://oras.land/docs/installation). Then, run the following command to install the Radius CLI:

```powershell
$script=iwr -useb "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.ps1"; $block=[ScriptBlock]::Create($script); invoke-command -ScriptBlock $block -ArgumentList edge
```

{{< /edge >}}
{{% /codetab %}}

{{% codetab %}}
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/radius-project/samples)
{{% /codetab %}}

{{% codetab %}}
[Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) is an interactive, authenticated, browser-accessible shell for managing Azure resources.

Azure Cloud Shell for bash doesn't have a sudo command, so users are unable to install Radius to the default `/usr/local/bin` installation path. To install the Radius CLI to the home directory, run the following commands:

```bash
export RADIUS_INSTALL_DIR=./
wget -q "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" -O - | /bin/bash
```

{{% /codetab %}}

{{% codetab %}}
Visit [Radius GitHub releases](https://github.com/radius-project/radius/releases) to select and download a specific version of the Radius CLI.

{{% /codetab %}}

{{< /tabs >}}

You may be prompted for your root or administrator password during installation. If you do not have permission to the default installation location, you can set the RADIUS_INSTALL_DIR environment variable with your preferred install directory.

Verify the Radius CLI is installed correctly by running `rad version`.
