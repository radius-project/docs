---
type: docs
title: "rad recipe show CLI reference"
linkTitle: "rad recipe show"
slug: rad_recipe_show
url: /reference/cli/rad_recipe_show/
description: "Details on the rad recipe show Radius CLI command"
---
## rad recipe show

Show recipe details

### Synopsis

Show recipe details

The recipe show command outputs details about a recipe. This includes the name, resource type, parameters, parameter details and template path.
	
By default, the command is scoped to the resource group and environment defined in your rad.yaml workspace file. You can optionally override these values through the environment and group flags.
	
By default, the command outputs a human-readable table. You can customize the output format with the output flag.

```
rad recipe show [recipe-name] [flags]
```

### Examples

```

# show the details of a recipe
rad recipe show redis-prod --resource-type Applications.Datastores/redisCaches

# show the details of a recipe, with a JSON output
rad recipe show redis-prod --resource-type Applications.Datastores/redisCaches --output json
	
# show the details of a recipe, with a specified environment and group
rad recipe show redis-dev --resource-type Applications.Datastores/redisCaches --group dev --environment dev
```

### Options

```
  -e, --environment string     The environment name
  -g, --group string           The resource group name
  -h, --help                   help for show
  -o, --output string          output format (supported formats are json, table) (default "table")
      --resource-type string   Specify the type of the portable resource this recipe can be consumed by
  -w, --workspace string       The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad recipe]({{< ref rad_recipe.md >}})	 - Manage recipes

