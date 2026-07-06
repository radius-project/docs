---
type: docs
title: "rad startup CLI reference"
linkTitle: "rad startup"
slug: rad_startup
url: /reference/cli/rad_startup/
description: "Details on the rad startup Radius CLI command"
---
## rad startup

Restore Radius state after startup

### Synopsis

Restore durable Radius state for the current workspace.

Opens the radius-state git orphan branch, waits for the control-plane PostgreSQL instance to be
ready, restores the control-plane databases, and re-creates the Terraform recipe state Secrets.
Run this after Radius is installed on a fresh cluster to resume from the state saved by
'rad shutdown'.

This command does not create the cluster or install Radius.

```
rad startup [flags]
```

### Examples

```

# Restore state for the current workspace
rad startup

# Restore state for a specific workspace
rad startup --workspace my-workspace
```

### Options

```
  -h, --help               help for startup
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI

