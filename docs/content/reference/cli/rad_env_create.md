---
type: docs
title: "rad env create CLI reference"
linkTitle: "rad env create"
slug: rad_env_create
url: /reference/cli/rad_env_create/
description: "Details on the rad env create Radius CLI command"
---
## rad env create

Create a new Radius Environment

### Synopsis

Create a new Radius Environment
Radius Environments are prepared "landing zones" for Radius Applications.
Applications deployed to an environment will inherit the container runtime, configuration, and other settings from the environment.

```
rad env create [envName] [flags]
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

* [rad env]({{< ref rad_env.md >}}) - Manage Radius Environments
