---
type: docs
title: "rad recipe unregister CLI reference"
linkTitle: "rad recipe unregister"
slug: rad_recipe_unregister
url: /reference/cli/rad_recipe_unregister/
description: "Details on the rad recipe unregister Radius CLI command"
---
## rad recipe unregister

Unregister a recipe from an environment

### Synopsis

Unregister a recipe from an environment

```
rad recipe unregister [recipe-name] [flags]
```

### Examples

```
rad recipe unregister cosmosdb
```

### Options

```
  -e, --environment string   The environment name
  -g, --group string         The resource group name
  -h, --help                 help for unregister
      --link-type string     Specify the type of the link this recipe can be consumed by
  -o, --output string        output format (supported formats are json, table) (default "table")
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad recipe]({{< ref rad_recipe.md >}})	 - Manage link recipes

