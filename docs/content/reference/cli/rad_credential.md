---
type: docs
title: "rad credential CLI reference"
linkTitle: "rad credential"
slug: rad_credential
url: /reference/cli/rad_credential/
description: "Details on the rad credential Radius CLI command"
---
## rad credential

Manage cloud provider credential for a Radius installation.

### Synopsis

Manage cloud provider credential for a Radius installation.

Radius cloud providers enable Radius Environments to deploy and integrate with cloud resources (Azure, AWS).
The Radius control-plane stores credentials for use when accessing cloud resources.

Cloud providers are configured per-Radius-installation. Configuration commands will use the current workspace
or the workspace specified by '--workspace' to configure Radius. Modifications to cloud provider configuration
or credentials will affect all Radius Environments and applications of the affected installation.

### Examples

```

# List configured cloud providers credential
rad credential list

# Register (Add or Update) cloud provider credential for Azure with service principal authentication
rad credential register azure sp --client-id <client id> --client-secret <client secret> --tenant-id <tenant id>
# Register (Add or Update) cloud provider credential for Azure with workload identity authentication
rad credential register azure wi --client-id <client id> --tenant-id <tenant id>
# Register (Add or update) cloud provider credential for AWS with access key authentication.
rad credential register aws access-key --access-key-id <access-key-id> --secret-access-key <secret-access-key>
# Register (Add or update) cloud provider credential for AWS with IRSA (IAM Roles for Service Accounts).
rad credential register aws irsa --iam-role <roleARN>

# Show cloud provider credential details for Azure
rad credential show azure
# Show cloud provider credential details for AWS
rad credential show aws

# Delete Azure cloud provider configuration
rad credential unregister azure
# Delete AWS cloud provider configuration
rad credential unregister aws

```

### Options

```
  -h, --help   help for credential
```

### Options inherited from parent commands

```
      --config string   config file (default "$HOME/.rad/config.yaml")
  -o, --output string   output format (supported formats are json, table) (default "table")
```

### SEE ALSO

* [rad]({{< ref rad.md >}})	 - Radius CLI
* [rad credential list]({{< ref rad_credential_list.md >}})	 - List configured cloud provider credentials
* [rad credential register]({{< ref rad_credential_register.md >}})	 - Register (Add or update) cloud provider credential for a Radius installation.
* [rad credential show]({{< ref rad_credential_show.md >}})	 - Show details of a configured cloud provider credential
* [rad credential unregister]({{< ref rad_credential_unregister.md >}})	 - Unregisters a configured cloud provider credential from the Radius installation

