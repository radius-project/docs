---
type: docs
title: "rad credential unregister CLI reference"
linkTitle: "rad credential unregister"
slug: rad_credential_unregister
url: /reference/cli/rad_credential_unregister/
description: "Details on the rad credential unregister Radius CLI command"
---
## rad credential unregister

Unregisters a configured cloud provider credential from the Radius installation

### Synopsis

Unregisters a configured cloud provider credential from the Radius installation.

Radius cloud providers enable Radius Environments to deploy and integrate with cloud resources (Azure, AWS).
The Radius control-plane stores credentials for use when accessing cloud resources.

Cloud providers are configured per-Radius-installation. Configuration commands will use the current workspace
or the workspace specified by '--workspace' to configure Radius. Modifications to cloud provider configuration
or credentials will affect all Radius Environments and applications of the affected installation.

```
rad credential unregister [flags]
```

### Examples

```

# Unregister Azure cloud provider credential
rad credential unregister azure

# Unregister AWS cloud provider credential
rad credential unregister aws

```

### Options

```
  -h, --help               help for unregister
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad credential]({{< ref rad_credential.md >}}) - Manage cloud provider credential for a Radius installation.
