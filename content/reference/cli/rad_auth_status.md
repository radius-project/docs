---
type: docs
title: "rad auth status CLI reference"
linkTitle: "rad auth status"
slug: rad_auth_status
url: /reference/cli/rad_auth_status/
description: "Details on the rad auth status Radius CLI command"
---
## rad auth status

Show current authorization mode, administrator status, and warnings

```
rad auth status [flags]
```

### Examples

```
rad auth status
```

### Options

```
  -h, --help[=true|false]   help for status
  -o, --output string       output format (supported formats are json, table) (default "table")
```

### Options inherited from parent commands

```
      --config string      config file (default "$HOME/.rad/config.yaml")
  -w, --workspace string   The workspace name
```

### SEE ALSO

* [rad auth]({{< ref rad_auth.md >}})	 - Inspect Radius identity and access

