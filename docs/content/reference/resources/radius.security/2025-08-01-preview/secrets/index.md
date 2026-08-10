---
type: docs
title: "Radius.Security/secrets@2025-08-01-preview"
linkTitle: "Secrets"
---

{{< schemaExample >}}

## Description

The Radius.Security/secrets Resource Type stores sensitive data such as tokens, passwords, keys, and certificates. To create a new Secret, start by adding parameter to your application definition decorated with `@secure()`. Then add a `secrets` resource. Never include secret values in an application definition. 
```bicep
  extension radius

  @description('The Radius environment ID')
  param environment string

  @secure()
  param password string

  resource myApplication 'Radius.Core/applications@2025-08-01-preview' = { 
    name: 'my-app'
    properties: {
      environment: environment
    }
  }

  // Passing password as a parameter to `rad deploy`
  // password=$(openssl rand -hex 16) 
  // rad deploy app.bicep -p password=$password
  resource dbCredentials 'Radius.Security/secrets@2025-08-01-preview' = {
    name: 'db-creds'
    properties: {
      environment: environment
      application: myApplication.id
      data: {
        username: {
          value: 'admin'
        }
        password: {
          // From password parameter passed in via CLI. 
          value: password
        }
      }
    }
  }
  ```
When deploying the application, specify the secret value as a command-line parameter. It is recommended to use a password generator such as `openssl` or equivalent. For example, `rad deploy app.bicep -p password=$(openssl rand -hex 16)`.
For details on how to use the secret with another resource such as a container or database, see the documentation for those resource types.

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
