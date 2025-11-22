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

Radius will be installed in the 'radius-system' namespace. For more information visit https://docs.radapp.io/concepts/

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

# Install Radius without Contour ingress controller
rad install kubernetes --skip-contour-install

# Install Radius with overrides in the current Kubernetes context
rad install kubernetes --set key=value

# Install Radius with a custom container registry
# Images will be pulled as: myregistry.azurecr.io/controller, myregistry.azurecr.io/ucpd, etc.
rad install kubernetes --set global.imageRegistry=myregistry.azurecr.io

# Install Radius with a specific version tag for all components
rad install kubernetes --set global.imageTag=0.48

# Install Radius with custom registry and tag
# Images will be pulled as: myregistry.azurecr.io/controller:0.48, etc.
rad install kubernetes --set global.imageRegistry=myregistry.azurecr.io,global.imageTag=0.48

# Install Radius with private registry and image pull secrets
# Note: Secret must be created in radius-system namespace first
rad install kubernetes --set global.imageRegistry=myregistry.azurecr.io --set-string 'global.imagePullSecrets[0].name=regcred'

# Install Radius with multiple image pull secrets for different registries
rad install kubernetes --set-string 'global.imagePullSecrets[0].name=azure-cred' \
                       --set-string 'global.imagePullSecrets[1].name=aws-cred'

# Install Radius with the intermediate root CA certificate in the current Kubernetes context
rad install kubernetes --set-file global.rootCA.cert=/path/to/rootCA.crt

# Install Radius with zipkin server for distributed tracing
rad install kubernetes --set global.zipkin.url=http://localhost:9411/api/v2/spans

# Install Radius with central prometheus monitoring service
rad install kubernetes --set global.prometheus.path=/customdomain.com/metrics,global.prometheus.port=443,global.rootCA.cert=/path/to/rootCA.crt

# Install Radius using a helmchart from specified file path
rad install kubernetes --chart /root/radius/deploy/Chart

# Force re-install Radius with latest version
rad install kubernetes --reinstall

# Install Radius with custom Terraform log level
rad install kubernetes --set global.terraform.loglevel=DEBUG

```

### Options

```
      --chart string                   Specify a file path to a helm chart to install Radius from
      --contour-chart string           Specify a local file path to a helm chart to install Contour from
      --contour-set stringArray        Set values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)
      --contour-set-file stringArray   Set values from files on the command line (can specify multiple or separate files with commas: key1=filename1,key2=filename2)
  -h, --help                           help for kubernetes
      --kubecontext string             The Kubernetes context to use, will use the default if unset
      --reinstall                      Specify to force reinstallation of Radius
      --set stringArray                Set values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)
      --set-file stringArray           Set values from files on the command line (can specify multiple or separate files with commas: key1=filename1,key2=filename2)
      --skip-contour-install           Install Contour ingress controller (enabled by default)
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad install]({{< ref rad_install.md >}})	 - Installs Radius for a given platform

