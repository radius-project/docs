---
type: docs
title: "rad application graph CLI reference"
linkTitle: "rad application graph"
slug: rad_application_graph
url: /reference/cli/rad_application_graph/
description: "Details on the rad application graph Radius CLI command"
---
## rad application graph

Shows the application graph for an application.

### Synopsis

Shows the application graph for an application.

```
rad application graph [flags]
```

### Examples

```

# Show graph for current application
rad app graph

# Show graph for specified application
rad app graph my-application
```

### Options

```
  -a, --application string   The application name
  -g, --group string         The resource group name
  -h, --help                 help for graph
  -o, --output string        output format (supported formats are json, table) (default "table")
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad application]({{< ref rad_application.md >}})	 - Manage Radius Applications

