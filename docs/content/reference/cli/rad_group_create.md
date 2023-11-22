---
type: docs
title: "rad group create CLI reference"
linkTitle: "rad group create"
slug: rad_group_create
url: /reference/cli/rad_group_create/
description: "Details on the rad group create Radius CLI command"
---
## rad group create

Create a new resource group

### Synopsis

Create a new resource group

Resource groups are used to organize and manage Radius resources. They often contain resources that share a common lifecycle or unit of deployment.

A Radius Application and its resources can span one or more resource groups, and do not have to be in the same resource group as the Radius Environment into which it's being deployed into.

Note that these resource groups are separate from the Azure cloud provider and Azure resource groups configured with the cloud provider.

```
rad group create resourcegroupname [flags]
```

### Examples

```
rad group create rgprod
```

### Options

```
  -g, --group string       The resource group name
  -h, --help               help for create
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad group]({{< ref rad_group.md >}}) - Manage resource groups
