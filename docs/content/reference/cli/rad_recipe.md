---
type: docs
title: "rad recipe CLI reference"
linkTitle: "rad recipe"
slug: rad_recipe
url: /reference/cli/rad_recipe/
description: "Details on the rad recipe Radius CLI command"
---
## rad recipe

Manage recipes

### Synopsis

Manage recipes
		Recipes automate the deployment of infrastructure and configuration of portable resources.

### Options

```
  -e, --environment string   The environment name
  -h, --help                 help for recipe
  -w, --workspace string     The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI
* [rad recipe list]({{< ref rad_recipe_list.md >}})	 - List recipes
* [rad recipe register]({{< ref rad_recipe_register.md >}})	 - Add a recipe to an environment.
* [rad recipe show]({{< ref rad_recipe_show.md >}})	 - Show recipe details
* [rad recipe unregister]({{< ref rad_recipe_unregister.md >}})	 - Unregister a recipe from an environment

