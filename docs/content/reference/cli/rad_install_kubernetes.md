---
type: docs
title: "rad install kubernetes CLI reference"
linkTitle: "rad install kubernetes"
slug: rad_install_kubernetes
url: /reference/cli/rad_install_kubernetes/
description: "Details on the rad install kubernetes Radius CLI command"
---
## rad install kubernetes

Installs Radius onto a kubernetes cluster

### Synopsis

Install Radius in a Kubernetes cluster using the Radius Helm chart.
By default 'rad install kubernetes' will install Radius with the version matching the rad CLI version.

Radius will be installed in the 'radius-system' namespace. For more information visit https://docs.radapp.io/concepts/technical/architecture/

Overrides can be set by specifying Helm chart values with the '--set' flag. For more information visit https://docs.radapp.io/guides/operations/kubernetes/install/.


```
rad install kubernetes [flags]
```

### Examples

```
# Install Radius with default settings in current Kubernetes context
rad install kubernetes

# Install Radius with default settings in specified Kubernetes context
rad install kubernetes --kubecontext mycluster

# Install Radius with overrides in the current Kubernetes context
rad install kubernetes --set key=value

# Install Radius with the intermediate root CA certificate in the current Kubernetes context
rad install kubernetes --set-file global.rootCA.cert=/path/to/rootCA.crt

# Install Radius from radius helmchart
rad install kubernetes --chart /root/radius/deploy/Chart

# Re-install Radius with latest version
rad install kubernetes --reinstall

```

### Options

```
      --chart string           Specify a file path to a helm chart to install Radius from
  -h, --help                   help for kubernetes
      --kubecontext string     The Kubernetes context to use, will use the default if unset
      --reinstall              Specify to force reinstallation of Radius
      --set stringArray        Set values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)
      --set-file stringArray   Set values from files on the command line (can specify multiple or separate files with commas: key1=filename1,key2=filename2)
```

### Install Radius using Helm
* Install Radius version from Helmchart repository - [rad install using Helmchart](https://docs.radapp.io/guides/operations/kubernetes/install/#install-with-helm)


### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad install]({{< ref rad_install.md >}})	 - Installs Radius for a given platform

