---
type: docs
title: "rad env switch CLI reference"
linkTitle: "rad env switch"
slug: rad_env_switch
url: /reference/cli/rad_env_switch/
description: "Details on the rad env switch Radius CLI command"
---
## rad env switch

Switch the current environment

### Synopsis

Switch the current environment

```
rad env switch [environment] [flags]
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

* [rad env]({{< ref rad_env.md >}}) - Manage Radius Environments
