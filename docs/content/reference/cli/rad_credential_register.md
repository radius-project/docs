---
type: docs
title: "rad credential register CLI reference"
linkTitle: "rad credential register"
slug: rad_credential_register
url: /reference/cli/rad_credential_register/
description: "Details on the rad credential register Radius CLI command"
---
## rad credential register

Register(Add or update) cloud provider credential for a Radius installation.

### Synopsis

Register (Add or update) cloud provider configuration for a Radius installation.

Radius cloud providers enable Radius environments to deploy and integrate with cloud resources (Azure, AWS).
The Radius control-plane stores credentials for use when accessing cloud resources.

Cloud providers are configured per-Radius-installation. Configuration commands will use the current workspace
or the workspace specified by '--workspace' to configure Radius. Modifications to cloud provider configuration
or credentials will affect all Radius environments and applications of the affected installation.

### Examples

```

# Register (Add or update) cloud provider credential for Azure with service principal authentication
rad credential register azure --client-id <client id> --client-secret <client secret> --tenant-id <tenant id> 	
# Register (Add or Update) cloud provider credential for AWS with IAM authentication
rad credential register aws --access-key-id <access-key-id> --secret-access-key <secret-access-key>	

```

### Options

```
  -h, --help   help for register
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad credential]({{< ref rad_credential.md >}})	 - Manage cloud provider credential for a Radius installation.
* [rad credential register aws]({{< ref rad_credential_register_aws.md >}})	 - Register (Add or update) AWS cloud provider credential for a Radius installation.
* [rad credential register azure]({{< ref rad_credential_register_azure.md >}})	 - Register (Add or update) Azure cloud provider credential for a Radius installation.

