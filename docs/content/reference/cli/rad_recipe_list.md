---
type: docs
title: "rad recipe list CLI reference"
linkTitle: "rad recipe list"
slug: rad_recipe_list
url: /reference/cli/rad_recipe_list/
description: "Details on the rad recipe list Radius CLI command"
---
## rad recipe list

List recipes

### Synopsis

List recipes within an environment

```
rad recipe list [flags]
```

### Examples

```
rad recipe list
```

### Options

```
  -e, --environment string   The environment name
  -g, --group string         The resource group name
  -h, --help                 help for list
  -o, --output string        output format (supported formats are json, table) (default "table")
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad recipe]({{< ref rad_recipe.md >}})	 - Manage recipes

