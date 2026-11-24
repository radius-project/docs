---
type: docs
title: "rad auth CLI reference"
linkTitle: "rad auth"
slug: rad_auth
url: /reference/cli/rad_auth/
description: "Details on the rad auth Radius CLI command"
---
## rad auth

Inspect Radius identity and access

### Options

```
  -h, --help[=true|false]   help for auth
  -w, --workspace string    The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI
* [rad auth access]({{< ref rad_auth_access.md >}})	 - Inspect Radius policy grants
* [rad auth status]({{< ref rad_auth_status.md >}})	 - Show current authorization mode, administrator status, and warnings
* [rad auth whoami]({{< ref rad_auth_whoami.md >}})	 - Show the verified identity, issuer, and groups Radius sees

