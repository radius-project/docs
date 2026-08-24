---
type: docs
title: "rad shutdown CLI reference"
linkTitle: "rad shutdown"
slug: rad_shutdown
url: /reference/cli/rad_shutdown/
description: "Details on the rad shutdown Radius CLI command"
---
## rad shutdown

Back up Radius state and prepare for shutdown

### Synopsis

Back up all durable Radius state for the current workspace.

Dumps the control-plane PostgreSQL databases and exports the Terraform recipe state Secrets,
commits them to the radius-state archive. The state can be restored into a fresh control plane
with 'rad startup'.

This command does not delete the cluster or uninstall Radius.

```
rad shutdown [flags]
```

### Examples

```

# Back up state for the current workspace
rad shutdown

# Back up state for a specific workspace
rad shutdown --workspace my-workspace
```

### Options

```
  -h, --help               help for shutdown
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI

