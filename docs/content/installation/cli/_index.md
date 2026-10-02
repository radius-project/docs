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

## Bicep compatibility for GHCR

The GHCR configuration examples in these edge docs are for the production Bicep extension registry migration. They require a Radius release that bundles Bicep CLI **v0.45.6 or later**. [Radius v0.61.1](https://github.com/radius-project/radius/releases/tag/v0.61.1) bundles Bicep **v0.46.1** and meets this compiler requirement, but public GHCR restore and compilation have not yet been verified. Do not use these configurations for a new installation or switch existing applications until the corresponding public extension artifacts are available and validated with the released Radius CLI. Radius releases that bundle Bicep v0.42.1 cannot restore these extensions.

Use `rad version` to check the Bicep version used by Radius. Installing a newer standalone Bicep CLI does not upgrade the compiler used by `rad`. Set `experimentalFeaturesEnabled.ociEnabled` to `true` in each effective `bicepconfig.json`, as shown in [Configure Bicep extensions]({{< ref "/installation/dev-workstation#configure-bicepconfigjson" >}}).

The production Radius and AWS Bicep extension packages will be public at `ghcr.io/radius-project/bicep-types-radius` and `ghcr.io/radius-project/bicep-types-aws`. Once published, these public extensions can be restored anonymously; no Azure or GitHub registry login is required. Authentication for private extension and recipe registries is unchanged.

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
