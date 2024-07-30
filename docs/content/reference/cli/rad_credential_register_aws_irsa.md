---
type: docs
title: "rad credential register aws irsa CLI reference"
linkTitle: "rad credential register aws irsa"
slug: rad_credential_register_aws_irsa
url: /reference/cli/rad_credential_register_aws_irsa/
description: "Details on the rad credential register aws irsa Radius CLI command"
---
## rad credential register aws irsa

Register (Add or update) AWS cloud provider credential for a Radius installation.

### Synopsis

Register (Add or update) AWS cloud provider credential for a Radius installation..

This command is intended for scripting or advanced use-cases. See 'rad init' for a user-friendly way
to configure these settings.

Radius will use the provided IAM credential for all interactions with AWS. 


Radius cloud providers enable Radius Environments to deploy and integrate with cloud resources (Azure, AWS).
The Radius control-plane stores credentials for use when accessing cloud resources.

Cloud providers are configured per-Radius-installation. Configuration commands will use the current workspace
or the workspace specified by '--workspace' to configure Radius. Modifications to cloud provider configuration
or credentials will affect all Radius Environments and applications of the affected installation.

```
rad credential register aws irsa [flags]
```

### Examples

```

# Register (Add or update) cloud provider credential for AWS with IRSA (IAM roles for service accounts) authentication
rad credential register aws irsa --iam-role <roleARN>

```

### Options

```
  -h, --help               help for irsa
      --iam-role string    RoleARN for AWS IRSA identity.
  -o, --output string      output format (supported formats are json, table) (default "table")
  -w, --workspace string   The workspace name
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
```

### SEE ALSO

* [rad credential register aws]({{< ref rad_credential_register_aws.md >}})	 - Register (Add or update) AWS cloud provider credential for a Radius installation.

