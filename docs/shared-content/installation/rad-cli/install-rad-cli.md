Install the Radius CLI on your workstation with the appropriate installation script:

{{< tabs Linux macOS "Windows PowerShell" "Windows WinGet" "GitHub Codespaces" Binaries >}}

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
{{< latest >}}
Run the following in a console window:

```shell
winget install --exact --id Radius.Radius
```

{{< /latest >}}
{{< edge >}}
Edge version installation via WinGet is not supported. To install the latest edge release, use the install script in the Windows PowerShell tab.
{{< /edge >}}
{{% /codetab %}}

{{% codetab %}}
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/radius-project/samples)
{{% /codetab %}}

{{% codetab %}}
Visit [Radius GitHub releases](https://github.com/radius-project/radius/releases) to select and download a specific version of the Radius CLI.

{{% /codetab %}}

{{< /tabs >}}

Verify the Radius CLI is installed correctly by running `rad version`.
