---
type: docs
title: "Radius CLI reference"
linkTitle: "rad CLI"
description: "Detailed reference documentation on the Radius CLI"
weight: 100
---

```bash
$ rad

Usage:
  rad [command]

Available Commands:
  application Manage RAD applications
  bicep       Manage bicep compiler
  completion  Generates shell completion scripts
  debug-logs  Captures information about the current Radius Workspace for debugging and diagnostics. Creates a ZIP file of logs in the current directory. WARNING Please inspect all logs before sending feedback to confirm no private information is included.
  deploy      Deploy a RAD application
  env         Manage environments
  help        Help about any command
  install     Installs radius for a given platform
  resource    Manage resources
  uninstall   Uninstall radius for a specific platform
  version     Prints the versions of the rad cli
  workspace   Manage local workspaces
  group       Manage resource groups

Flags:
      --config string   config file (default is $HOME/.rad/config.yaml)
  -h, --help            help for rad
  -v, --version         version for radius

Use "rad [command] --help" for more information about a command.
```

## Global flags

| Flag | Default | Description |
|------|---------|-------------|
| `--config` | `$HOME/.rad/config.yaml` | config file

## Available commands
