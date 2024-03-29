---
type: docs
title: "rad credential show CLI reference"
linkTitle: "rad credential show"
slug: rad_credential_show
url: /reference/cli/rad_credential_show/
description: "Details on the rad credential show Radius CLI command"
---
## rad credential show

Show details of a configured cloud provider credential

### Synopsis

Show details of a configured cloud provider credential.

Radius cloud providers enable Radius Environments to deploy and integrate with cloud resources (Azure, AWS).
The Radius control-plane stores credentials for use when accessing cloud resources.

Cloud providers are configured per-Radius-installation. Configuration commands will use the current workspace
or the workspace specified by '--workspace' to configure Radius. Modifications to cloud provider configuration
or credentials will affect all Radius Environments and applications of the affected installation.

```
rad credential show [name] [flags]
```

### Examples

```

# Show cloud providers details for Azure
rad credential show azure

# Show cloud providers details for AWS
rad credential show aws

```

### Options

```
  -h, --help               help for show
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad credential]({{< ref rad_credential.md >}})	 - Manage cloud provider credential for a Radius installation.

