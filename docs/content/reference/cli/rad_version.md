---
type: docs
title: "rad version CLI reference"
linkTitle: "rad version"
slug: rad_version
url: /reference/cli/rad_version/
description: "Details on the rad version Radius CLI command"
---
## rad version

Prints the versions of the rad CLI and the Radius Control Plane

### Synopsis

Display version information for the rad CLI installed on your machine and the Radius Control Plane running on your cluster.
By default this shows all available version information.

```
rad version [flags]
```

### Examples

```
# Show all version information
rad version

# Show only the CLI version
rad version --cli
```

### Options

```
      --cli    Use this flag to only show the rad CLI version
  -h, --help   help for version
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI

