---
type: docs
title: "rad environment CLI reference"
linkTitle: "rad environment"
slug: rad_environment
url: /reference/cli/rad_environment/
description: "Details on the rad environment Radius CLI command"
---
## rad environment

Manage Radius Environments

### Synopsis

Manage Radius Environments
Radius Environments are prepared “landing zones” for Radius Applications. Applications deployed to an environment will inherit the container runtime, configuration, and other settings from the environment.

### Options

```
  -e, --environment string   The environment name
  -h, --help                 help for environment
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI
* [rad environment create]({{< ref rad_environment_create.md >}})	 - Create a new Radius Environment
* [rad environment delete]({{< ref rad_environment_delete.md >}})	 - Delete environment
* [rad environment list]({{< ref rad_environment_list.md >}})	 - List environments
* [rad environment show]({{< ref rad_environment_show.md >}})	 - Show environment details
* [rad environment switch]({{< ref rad_environment_switch.md >}})	 - Switch the current environment
* [rad environment update]({{< ref rad_environment_update.md >}})	 - Update environment configuration

