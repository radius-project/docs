---
type: docs
title: "rad debug-logs CLI reference"
linkTitle: "rad debug-logs"
slug: rad_debug-logs
url: /reference/cli/rad_debug-logs/
description: "Details on the rad debug-logs Radius CLI command"
---
## rad debug-logs

Capture logs from Radius control plane for debugging and diagnostics.

### Synopsis

Capture logs from Radius control plane for debugging and diagnostics.
	
Creates a ZIP file of logs in the current directory.

WARNING Please inspect all logs before sending feedback to confirm no private information is included.


```
rad debug-logs [flags]
```

### Options

```
  -h, --help               help for debug-logs
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI

