---
type: docs
title: "rad credential register azure CLI reference"
linkTitle: "rad credential register azure"
slug: rad_credential_register_azure
url: /reference/cli/rad_credential_register_azure/
description: "Details on the rad credential register azure Radius CLI command"
---
## rad credential register azure

Register (Add or update) Azure cloud provider credential for a Radius installation.

### Synopsis

Register (Add or update) Azure cloud provider credential for a Radius installation.

Radius cloud providers enable Radius Environments to deploy and integrate with cloud resources (Azure, AWS).
The Radius control-plane stores credentials for use when accessing cloud resources.

Cloud providers are configured per-Radius-installation. Configuration commands will use the current workspace
or the workspace specified by '--workspace' to configure Radius. Modifications to cloud provider configuration
or credentials will affect all Radius Environments and applications of the affected installation.

### Examples

```

# Register (Add or update) cloud provider credential for Azure with service principal authentication
rad credential register azure sp --client-id <client id> --client-secret <client secret> --tenant-id <tenant id>
# Register (Add or update) cloud provider credential for Azure with workload identity authentication
rad credential register azure wi --client-id <client id> --tenant-id <tenant id>

```

### Options

```
  -h, --help   help for azure
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad credential register]({{< ref rad_credential_register.md >}})	 - Register (Add or update) cloud provider credential for a Radius installation.
* [rad credential register azure sp]({{< ref rad_credential_register_azure_sp.md >}})	 - Register (Add or update) Azure cloud provider service principal credential for a Radius installation.
* [rad credential register azure wi]({{< ref rad_credential_register_azure_wi.md >}})	 - Register (Add or update) Azure cloud provider workload identity credential for a Radius installation.

