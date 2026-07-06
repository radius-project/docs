---
type: docs
title: "rad resource expose CLI reference"
linkTitle: "rad resource expose"
slug: rad_resource_expose
url: /reference/cli/rad_resource_expose/
description: "Details on the rad resource expose Radius CLI command"
---
## rad resource expose

Exposes a resource for network traffic

### Synopsis

Exposes a port inside a resource for network traffic using a local port.
This command is useful for testing resources that accept network traffic but are not exposed to the public internet. Exposing a port for testing allows you to send TCP traffic from your local machine to the resource.

Press CTRL+C to exit the command and terminate the tunnel.

```
rad resource expose [type] [resource] [flags]
```

### Examples

```
# expose port 80 on the 'orders' resource of the 'icecream-store' application
# on local port 5000
rad resource expose --application icecream-store Applications.Core/containers orders --port 5000 --remote-port 80

# expose port 80 using the preview resource type 'Radius.Compute/containers'
rad resource expose --application icecream-store Radius.Compute/containers orders --port 5000 --remote-port 80 --preview
```

### Options

```
  -g, --group string      The resource group name
  -h, --help              help for expose
  -p, --port int          specify the local port (default -1)
      --preview           Use the Radius.Core preview implementation (can also be set via RADIUS_PREVIEW=true)
      --remote-port int   specify the remote port (default -1)
      --replica string    specify the replica to expose
  -r, --resource string   The resource name
  -t, --type string       The resource type
```

### Options inherited from parent commands

```
  -a, --application string   The application name
      --config string        config file (default "$HOME/.rad/config.yaml")
  -o, --output string        output format (supported formats are json, table) (default "table")
  -w, --workspace string     The workspace name
```

### SEE ALSO

* [rad resource]({{< ref rad_resource.md >}})	 - Manage resources

