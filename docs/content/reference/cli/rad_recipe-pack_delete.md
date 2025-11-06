---
type: docs
title: "rad recipe-pack delete CLI reference"
linkTitle: "rad recipe-pack delete"
slug: rad_recipe-pack_delete
url: /reference/cli/rad_recipe-pack_delete/
description: "Details on the rad recipe-pack delete Radius CLI command"
---
## rad recipe-pack delete

Delete recipe pack

### Synopsis

Delete a recipe pack from the current workspace scope.

```
rad recipe-pack delete [flags]
```

### Examples

```

# Delete specified recipe pack
rad recipe-pack delete my-recipe-pack

# Delete recipe pack in a specified resource group
rad recipe-pack delete my-recipe-pack --group my-group

# Delete recipe pack and bypass confirmation prompt
rad recipe-pack delete my-recipe-pack --yes

```

### Options

```
  -g, --group string       The resource group name
  -h, --help               help for delete
  -w, --workspace string   The workspace name
  -y, --yes                The confirmation flag
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad recipe-pack]({{< ref rad_recipe-pack.md >}})	 - Manage recipe-packs

