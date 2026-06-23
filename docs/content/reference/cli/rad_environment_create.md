---
type: docs
title: "rad environment create CLI reference"
linkTitle: "rad environment create"
slug: rad_environment_create
url: /reference/cli/rad_environment_create/
description: "Details on the rad environment create Radius CLI command"
---
## rad environment create

Create a new Radius Environment

### Synopsis

Create a new Radius Environment
Radius Environments are prepared "landing zones" for Radius Applications.
Applications deployed to an environment will inherit the container runtime, configuration, and other settings from the environment.

```
rad environment create [envName] [flags]
```

### Examples

```

## Create environment with default namespace
rad env create myenv

## Create environment with a specific namespace
rad env create myenv --kubernetes-namespace mynamespace

## Create environment with Azure cloud provider
rad env create myenv --azure-subscription-id <subscription-id> --azure-resource-group <resource-group>

## Create environment with AWS cloud provider
rad env create myenv --aws-region <region> --aws-account-id <account-id>

```

### Options

```
      --aws-account-id string          The account ID where AWS resources will be deployed
      --aws-region string              The region where AWS resources will be deployed
      --azure-resource-group string    The resource group where Azure resources will be deployed
      --azure-subscription-id string   The subscription ID where Azure resources will be deployed
  -e, --environment string             The environment name
  -g, --group string                   The resource group name
  -h, --help                           help for create
      --kubernetes-namespace string    The namespace where Kubernetes resources will be deployed
      --preview                        Use the Radius.Core preview implementation (can also be set via RADIUS_PREVIEW=true)
  -w, --workspace string               The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad environment]({{< ref rad_environment.md >}})	 - Manage Radius Environments

