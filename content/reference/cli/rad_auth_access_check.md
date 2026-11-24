---
type: docs
title: "rad auth access check CLI reference"
linkTitle: "rad auth access check"
slug: rad_auth_access_check
url: /reference/cli/rad_auth_access_check/
description: "Details on the rad auth access check Radius CLI command"
---
## rad auth access check

Check policy grants independently of workload enforcement mode

### Synopsis

Check policy grants independently of workload enforcement mode. Self checks include verified groups. Another group requires checkAccess permission; another user's or workload's memberships cannot be resolved and return an explicit error.

```
rad auth access check [flags]
```

### Examples

```
rad auth access check --action Radius.Core/applications/read --scope /planes/radius/local/resourceGroups/team-a
```

### Options

```
      --action stringArray   Permission to check (repeat for a batch)
  -h, --help[=true|false]    help for check
      --issuer string        Principal issuer (defaults to the current caller's verified issuer)
  -o, --output string        output format (supported formats are json, table) (default "table")
      --principal string     Principal as user:<subject>, group:<subject>, or workload:<subject>; defaults to the caller
      --scope string         Inspection scope (defaults to the workspace resource group); use / for installation
      --target stringArray   Concrete target per action (defaults to scope; repeat in action order)
```

### Options inherited from parent commands

```
      --config string      config file (default "$HOME/.rad/config.yaml")
  -w, --workspace string   The workspace name
```

### SEE ALSO

* [rad auth access]({{< ref rad_auth_access.md >}})	 - Inspect Radius policy grants

