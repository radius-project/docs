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

When invoked with the name of a deployed application using the --application flag,
the command queries the Radius control plane and prints the graph of live
resources. When invoked with a path to an app.bicep,
the command compiles the template and writes the resulting modeled graph to
./app-graph.json without contacting the control plane.

If the command runs inside a GitHub Actions runner (GITHUB_ACTIONS=true), the
modeled graph is saved to <source-branch>/app-graph.json in the radius-graph
archive instead of the local filesystem. This is auto-detected; no flag
is required.

```
rad application graph [flags]
```

### Examples

```

# Show graph for the deployed application named my-application.
rad app graph -a my-application

# Build the modeled graph for an app.bicep and write it to ./app-graph.json.
rad app graph ./app.bicep
```

### Options

```
  -a, --application string   The application name
  -g, --group string         The resource group name
  -h, --help                 help for graph
      --include-icons        When set with --preview (deployed) or with a bicep-file argument (modeled), embeds each referenced resource type icon's SVG bytes in the response's icons map.
  -o, --output string        output format (supported formats are json, table) (default "table")
      --preview              Use the Radius.Core preview implementation (can also be set via RADIUS_PREVIEW=true)
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad application]({{< ref rad_application.md >}})	 - Manage Radius Applications

