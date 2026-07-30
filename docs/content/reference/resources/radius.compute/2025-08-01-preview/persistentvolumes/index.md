---
type: docs
title: "Radius.Compute/persistentVolumes@2025-08-01-preview"
linkTitle: "PersistentVolumes"
---

{{< schemaExample >}}

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `allowedAccessModes` | string | (Optional) The access modes which are permitted to be requested by a Container. Assumed to be all modes if not specified.<br />Allowed values: `ReadOnlyMany`, `ReadWriteMany`, `ReadWriteOnce`. |
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `sizeInGib` | integer | (Required) The size of the volume in gibibytes. `1` represents 1024 MiB. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |
