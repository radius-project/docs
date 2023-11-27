---
type: docs
title: "rad application switch CLI reference"
linkTitle: "rad application switch"
slug: rad_application_switch
url: /reference/cli/rad_application_switch/
description: "Details on the rad application switch Radius CLI command"
---
## rad application switch

Switch the default Radius Application

### Synopsis

Switches the default Radius Application

```
rad application switch [flags]
```

### Examples

```
rad app switch newApplication
```

### Options

```
  -a, --application string   The application name
  -h, --help                 help for switch
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad application]({{< ref rad_application.md >}})	 - Manage Radius Applications

