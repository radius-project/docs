---
type: docs
title: "rad recipe-pack show CLI reference"
linkTitle: "rad recipe-pack show"
slug: rad_recipe-pack_show
url: /reference/cli/rad_recipe-pack_show/
description: "Details on the rad recipe-pack show Radius CLI command"
---
## rad recipe-pack show

Show recipe pack details

### Synopsis

Show recipe pack details

```
rad recipe-pack show [flags]
```

### Examples

```


# Show specified recipe pack
rad recipe-show show my-recipe-pack

# Show specified recipe pack in a specified resource group
rad recipe-show show my-recipe-pack --group my-group

```

### Options

```
  -g, --group string       The resource group name
  -h, --help               help for show
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad recipe-pack]({{< ref rad_recipe-pack.md >}})	 - Manage recipe-packs

