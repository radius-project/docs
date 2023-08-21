---
type: docs
title: "rad application delete CLI reference"
linkTitle: "rad application delete"
slug: rad_application_delete
url: /reference/cli/rad_application_delete/
description: "Details on the rad application delete Radius CLI command"
---
## rad application delete

Delete Radius application

### Synopsis

Delete the specified Radius application deployed in the default environment

```
rad application delete [flags]
```

### Examples

```

# Delete current application
rad app delete

# Delete current application and bypass confirmation prompt
rad app delete --yes

# Delete specified application
rad app delete my-app

# Delete specified application in a specified resource group
rad app delete my-app --group my-group

```

### Options

```
  -a, --application string   The application name
  -g, --group string         The resource group name
  -h, --help                 help for delete
  -w, --workspace string     The workspace name
  -y, --yes                  The confirmation flag
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad application]({{< ref rad_application.md >}})	 - Manage Radius applications

