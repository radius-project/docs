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

When invoked with the name of a deployed application, either as an argument or
with the --application flag, the command queries the Radius control plane and
prints the deployed graph computed from stored resources (Kind: Connection
edges only).

When invoked with --application <name> AND a path to the application's
app.bicep, the command additionally compiles the template locally, extracts the
dependsOn edges implied by it, and sends them to the server. The server merges
them onto the deployed graph as Kind: Dependency edges. Any edge already present
as Kind: Connection wins; excluded types and unknown endpoints are dropped.

When invoked with only a path to an app.bicep (no --application), the command
compiles the template and writes the resulting modeled graph to
./app-graph.json without contacting the control plane.

If the modeled graph is built inside a GitHub Actions runner
(GITHUB_ACTIONS=true), it is saved to <source-branch>/app-graph.json in the
radius-graph OCI archive instead of the local filesystem. Configure
RADIUS_GRAPH_REGISTRY with an OCI repository and authenticate to the registry.
Local output does not require a registry.

```
rad application graph [flags]
```

### Examples

```

# Show graph for the deployed application named my-application
rad app graph my-application

# Include icon SVG bytes inline in the JSON output
rad app graph my-application -o json --include-icons

# Enrich the deployed graph with dependsOn edges from a local app.bicep
rad app graph -a my-application ./app.bicep

# Build the modeled graph for an app.bicep and write it to ./app-graph.json
rad app graph ./app.bicep
```

### Options

```
  -a, --application string   The application name
  -g, --group string         The resource group name
  -h, --help                 help for graph
      --include-icons        When set, embeds each referenced resource type icon's SVG bytes in the response's icons map.
  -o, --output string        output format (supported formats are json, table) (default "table")
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad application]({{< ref rad_application.md >}})	 - Manage Radius Applications

