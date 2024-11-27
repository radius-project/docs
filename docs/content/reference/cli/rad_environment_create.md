---
type: docs
title: "rad environment create CLI reference"
linkTitle: "rad environment create"
slug: rad_environment_create
url: /reference/cli/rad_environment_create/
description: "Details on the rad environment create Radius CLI command"
---
## rad environment create

Create a new Radius Environment

### Synopsis

Create a new Radius Environment
Radius Environments are prepared "landing zones" for Radius Applications.
Applications deployed to an environment will inherit the container runtime, configuration, and other settings from the environment.

```
rad environment create [envName] [flags]
```

### Examples

```
rad env create myenv
```

### Options

```
  -e, --environment string   The environment name
  -g, --group string         The resource group name
  -h, --help                 help for create
  -n, --namespace string     The Kubernetes namespace
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad environment]({{< ref rad_environment.md >}})	 - Manage Radius Environments

