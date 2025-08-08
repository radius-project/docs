---
type: docs
title: "rad upgrade kubernetes CLI reference"
linkTitle: "rad upgrade kubernetes"
slug: rad_upgrade_kubernetes
url: /reference/cli/rad_upgrade_kubernetes/
description: "Details on the rad upgrade kubernetes Radius CLI command"
---
## rad upgrade kubernetes

Upgrades Radius on a Kubernetes cluster

### Synopsis

Upgrade Radius in a Kubernetes cluster using the Radius Helm chart.
This command upgrades the Radius control plane in the cluster associated with the active workspace.
To upgrade Radius in a different cluster, switch to the appropriate workspace first using 'rad workspace switch'.

The upgrade process includes preflight checks to ensure the cluster is ready for upgrade.
Preflight checks include:
- Kubernetes connectivity and permissions
- Helm connectivity and Radius installation status
- Version compatibility validation
- Cluster resource availability
- Custom configuration parameter validation

Radius is installed in the 'radius-system' namespace. For more information visit https://docs.radapp.io/concepts/technical/architecture/.


```
rad upgrade kubernetes [flags]
```

### Examples

```
# Upgrade Radius in the cluster of the active workspace
rad upgrade kubernetes

# Check which workspace is active
rad workspace show

# Switch to a different workspace before upgrading
rad workspace switch myworkspace
rad upgrade kubernetes

# Upgrade Radius with custom configuration
rad upgrade kubernetes --set key=value

# Upgrade Radius with a custom container registry
# Images will be pulled as: myregistry.azurecr.io/controller, myregistry.azurecr.io/ucpd, etc.
rad upgrade kubernetes --set global.imageRegistry=myregistry.azurecr.io

# Upgrade Radius to a specific version tag for all components
rad upgrade kubernetes --set global.imageTag=0.48

# Upgrade Radius with custom registry and tag
# Images will be pulled as: myregistry.azurecr.io/controller:0.48, etc.
rad upgrade kubernetes --set global.imageRegistry=myregistry.azurecr.io,global.imageTag=0.48

# Upgrade to a specific version
rad upgrade kubernetes --version 0.47.0

# Upgrade to the latest available version
rad upgrade kubernetes --version latest

# Upgrade Radius with values from a file
rad upgrade kubernetes --set-file global.rootCA.cert=/path/to/rootCA.crt

# Skip preflight checks (not recommended)
rad upgrade kubernetes --skip-preflight

# Run only preflight checks without upgrading
rad upgrade kubernetes --preflight-only

# Upgrade Radius using a Helm chart from specified file path
rad upgrade kubernetes --chart /root/radius/deploy/Chart

```

### Options

```
      --chart string           Specify a file path to a helm chart to upgrade Radius from
  -h, --help                   help for kubernetes
      --kubecontext string     The Kubernetes context to use, will use the default if unset
      --preflight-only         Run only preflight checks without performing the upgrade
      --set stringArray        Set values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)
      --set-file stringArray   Set values from files on the command line (can specify multiple or separate files with commas: key1=filename1,key2=filename2)
      --skip-preflight         Skip preflight checks before upgrade (not recommended)
      --version string         Specify the version to upgrade to (default: CLI version, use 'latest' for latest available)
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad upgrade]({{< ref rad_upgrade.md >}})	 - Upgrades Radius for a given platform

