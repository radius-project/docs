---
type: docs
title: "Radius.Security/secrets@2025-08-01-preview"
linkTitle: "Secrets"
---

{{< schemaExample >}}

## Top-Level Properties

| Property | Type | Description |
|----------|------|-------------|
| `application` | string | (Optional) The Radius Application ID. `myApplication.id` for example. |
| `codeReference` | string | Optional URI to the source code of this resource type. ex: https://github.com/radius-project/radius/blob/4fab87e8127adf1db6f43b7029d5235fbe82c5c9/cmd/controller/main.go#L27 |
| `connections` | [object](#connections) | Map of connection name to connection data. |
| `data` | [object](#data) | (Required) Map of secret data. For example: `data: { username: { value: user1 } password: { value: pass }}` |
| `environment` | string | (Required) The Radius Environment ID. Typically set by the rad CLI. Typically value should be `environment`. |
| `kind` | string | (Optional) The kind of content of the secret. If not specified, generic is assumed. basicAuthentication, awsIRSA, and azureWorkloadIdentity should only be used for configuring authentication to OCI registries for storing Bicep templates. This will change in the future.<br />Allowed values: `awsIRSA`, `azureWorkloadIdentity`, `basicAuthentication`, `certificate-pem`, `certificate-pkcs12`, `generic`. |

## Object Properties

### `connections` {#connections}

| Property | Type | Description |
|----------|------|-------------|
| `disableDefaultEnvVars` | boolean | Disables the automatic injection of environment variables from the connected resource's properties. |
| `source` | string | Resource ID of the source resource for this connection. |

### `data` {#data}

| Property | Type | Description |
|----------|------|-------------|
| `encoding` | string | (Optional) Content encoding of the value. If not specified, `string` is assumed.<br />Allowed values: `base64`, `string`. |
| `value` | string | (Required) The string value of the secret unless encoding is set to 'base64'. |
