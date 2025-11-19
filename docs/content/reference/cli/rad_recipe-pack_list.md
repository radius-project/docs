---
type: docs
title: "rad recipe-pack list CLI reference"
linkTitle: "rad recipe-pack list"
slug: rad_recipe-pack_list
url: /reference/cli/rad_recipe-pack_list/
description: "Details on the rad recipe-pack list Radius CLI command"
---
## rad recipe-pack list

List recipe packs

### Synopsis

Lists all recipe packs in all scopes

```
rad recipe-pack list [flags]
```

### Examples

```
rad recipe-packs list
```

### Options

```
  -g, --group string       The resource group name
  -h, --help               help for list
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad recipe-pack]({{< ref rad_recipe-pack.md >}})	 - Manage recipe-packs

