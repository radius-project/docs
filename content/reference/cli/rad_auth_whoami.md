---
type: docs
title: "rad auth whoami CLI reference"
linkTitle: "rad auth whoami"
slug: rad_auth_whoami
url: /reference/cli/rad_auth_whoami/
description: "Details on the rad auth whoami Radius CLI command"
---
## rad auth whoami

Show the verified identity, issuer, and groups Radius sees

```
rad auth whoami [flags]
```

### Examples

```
rad auth whoami --output json
```

### Options

```
  -h, --help[=true|false]   help for whoami
  -o, --output string       output format (supported formats are json, table) (default "table")
```

### Options inherited from parent commands

```
      --config string      config file (default "$HOME/.rad/config.yaml")
  -w, --workspace string   The workspace name
```

### SEE ALSO

* [rad auth]({{< ref rad_auth.md >}})	 - Inspect Radius identity and access

