---
type: docs
title: "rad credential list CLI reference"
linkTitle: "rad credential list"
slug: rad_credential_list
url: /reference/cli/rad_credential_list/
description: "Details on the rad credential list Radius CLI command"
---
## rad credential list

List configured cloud provider credentials

### Synopsis

List configured cloud providers credentials.

Radius cloud providers enable Radius Environments to deploy and integrate with cloud resources (Azure, AWS).
The Radius control-plane stores credentials for use when accessing cloud resources.

Cloud providers are configured per-Radius-installation. Configuration commands will use the current workspace
or the workspace specified by '--workspace' to configure Radius. Modifications to cloud provider configuration
or credentials will affect all Radius Environments and applications of the affected installation.

```
rad credential list [flags]
```

### Examples

```

# List configured cloud provider credentials
rad credential list

```

### Options

```
  -h, --help               help for list
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad credential]({{< ref rad_credential.md >}})	 - Manage cloud provider credential for a Radius installation.

