---
type: docs
title: "rad env CLI reference"
linkTitle: "rad env"
slug: rad_env
url: /reference/cli/rad_env/
description: "Details on the rad env Radius CLI command"
---
## rad env

Manage Radius Environments

### Synopsis

Manage Radius Environments
Radius Environments are prepared “landing zones” for Radius Applications. Applications deployed to an environment will inherit the container runtime, configuration, and other settings from the environment.

### Options

```
  -e, --environment string   The environment name
  -h, --help                 help for env
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI
* [rad env create]({{< ref rad_env_create.md >}})	 - Create a new Radius Environment
* [rad env delete]({{< ref rad_env_delete.md >}})	 - Delete environment
* [rad env list]({{< ref rad_env_list.md >}})	 - List environments
* [rad env show]({{< ref rad_env_show.md >}})	 - Show environment details
* [rad env switch]({{< ref rad_env_switch.md >}})	 - Switch the current environment
* [rad env update]({{< ref rad_env_update.md >}})	 - Update environment configuration

