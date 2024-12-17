---
type: docs
title: "rad environment switch CLI reference"
linkTitle: "rad environment switch"
slug: rad_environment_switch
url: /reference/cli/rad_environment_switch/
description: "Details on the rad environment switch Radius CLI command"
---
## rad environment switch

Switch the current environment

### Synopsis

Switch the current environment

```
rad environment switch [environment] [flags]
```

### Examples

```
rad env switch newEnvironment
```

### Options

```
  -e, --environment string   The environment name
  -h, --help                 help for switch
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad environment]({{< ref rad_environment.md >}})	 - Manage Radius Environments

