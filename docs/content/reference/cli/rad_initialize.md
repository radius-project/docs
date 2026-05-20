---
type: docs
title: "rad initialize CLI reference"
linkTitle: "rad initialize"
slug: rad_initialize
url: /reference/cli/rad_initialize/
description: "Details on the rad initialize Radius CLI command"
---
## rad initialize

Initialize Radius

### Synopsis


Interactively install the Radius control-plane and setup an environment.

If an environment already exists, 'rad init' will prompt the user to use the existing environment or create a new one.

By default, 'rad init' will optimize for a developer-focused environment with an environment named "default" and Recipes that support prototyping, development and testing using lightweight containers. These environments are great for building and testing your application.

Specifying the '--full' flag will cause 'rad init' to prompt the user for all available configuration options such as Kubernetes context, environment name, and cloud providers. This is useful for fully customizing your environment.


```
rad initialize [flags]
```

### Examples

```

## Create a new development environment named "default"
rad init

## Prompt the user for all available options to create a new environment
rad init --full

## Initialize with a custom container registry
## Images will be pulled as: myregistry.azurecr.io/controller, myregistry.azurecr.io/ucpd, etc.
rad init --set global.imageRegistry=myregistry.azurecr.io

## Initialize with a specific version tag
rad init --set global.imageTag=0.48

## Initialize with custom registry and tag
## Images will be pulled as: myregistry.azurecr.io/controller:0.48, etc.
rad init --set global.imageRegistry=myregistry.azurecr.io,global.imageTag=0.48

## Initialize with private registry and image pull secrets
## Note: Secret must be created in radius-system namespace first
rad init --set global.imageRegistry=myregistry.azurecr.io --set 'global.imagePullSecrets[0].name=regcred'

## Initialize with multiple image pull secrets for different registries
rad init --set 'global.imagePullSecrets[0].name=azure-cred' \
         --set 'global.imagePullSecrets[1].name=aws-cred'

## Initialize with custom values from a file
rad init --set-file global.rootCA.cert=/path/to/rootCA.crt

```

### Options

```
      --full                   Prompt user for all available configuration options
  -h, --help                   help for initialize
  -o, --output string          output format (supported formats are json, table) (default "table")
      --preview                Use the Radius.Core preview implementation
      --set stringArray        Set values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)
      --set-file stringArray   Set values from files on the command line (can specify multiple or separate files with commas: key1=filename1,key2=filename2)
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI

