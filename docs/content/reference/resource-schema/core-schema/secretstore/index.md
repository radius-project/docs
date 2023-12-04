---
type: docs
title: "Radius Secret Store"
linkTitle: "Secret Store"
description: "Learn how to define a secret store"
---

Note that only Kubernetes Secrets are currently supported with more to come in the future.

## Resource format

### Creating a new Secret Store

{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRET_STORE_NEW" >}}

### Referencing an existing Secret Store

{{< rad file="snippets/secretstore.bicep" embed=true marker="//SECRET_STORE_REF" >}}

### Top-level

| Key  | Required | Description | Example |
|------|:--------:|-------------|---------|
| name | y | The name of your Secret Store. | `'secret'`
| location | y | The location of your resource. See [common values]({{< ref "resource-schema.md#common-values" >}}) for more information. | `global`
| [properties](#properties) | y | Properties of the resource. | [See below](#properties)

#### properties

| Key | Required | Description | Example |
|----------|:--------:|-------------|---------|
| application | y | The ID of the application resource this resource belongs to. | `app.id` |
| resource | n | Reference to the backing secret store resource, required only if valueFrom specifies referenced secret name. | `namespace/secretName` |
| type | y | The type of secret in your resource. | `'certificate'`
| [data](#data) | y | An object to represent key-value type secrets. | [See below](#data)

##### data

This property is an object to represent key-value type secrets. You define your own key for each secret (e.g. `'tls.key'`), with the `encoding`, `value`, and `valueFrom` properties representing each secret value:

| Key | Required | Description | Example |
|------|:--------:|-------------|---------|
| value | y | The value of the secret key. | `'secretString'`
| encoding | n | The encoding type of the data value (default is `'raw'`). | `'base64'`
| [valueFrom](#valuefrom) | n | A reference to an external secret. This field is currently not in use, as it is meant for supporting more types of external secrets in the future. | [See below](#valuefrom)

###### valueFrom

*Note:* `valueFrom` is not supported for Kubernetes Secrets, but may be used for other secret store types in the future.

| Key | Required | Description | Example |
|------------|:--------:|-------------|---------|
| name | y | The name of the secret or key of `properties.resource`. | `'secret_key1_name'`
| version | n | The version of the secret. | `1`