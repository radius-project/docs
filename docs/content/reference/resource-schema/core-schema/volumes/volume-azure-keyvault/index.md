---
type: docs
title: "Azure Key Vault volume"
linkTitle: "Azure Key Vault"
description: "Learn about Radius persistent Azure Key Vault volumes"
slug: "azure-keyvault"
---

Radius supports mounting an Azure Key Vault as a persistent volume to the container using the Azure KeyVault CSI Driver.

## Prerequisites

- [Azure Key Vault CSI Driver](https://azure.github.io/secrets-store-csi-driver-provider-azure/demos/standard-walkthrough/) installed on your cluster
- [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) installed on your cluster
- `azure.com.workload` identity configured on your [environment]({{< ref "deploy-apps/environments/overview" >}})
- Your Azure Key Vault access policy should be set to [Azure role-based access control](https://learn.microsoft.com/azure/key-vault/general/rbac-guide?tabs=azure-cli)

## Resource format

{{< rad file="snippets/volume-keyvault.bicep" embed=true marker="//VOLUME" >}}

### Properties

The following properties are available on the `Volume` resource to which the container attaches:

| Key  | Required | Description | Example |
|------|:--------:|:------------|---------|
| kind | y | The kind of persistent volume. Should be 'azure.com.keyvault' for Azure Key Vault persistent volumes | `'azure.com.keyvault'`
| resource | n | Resource ID for the Azure KeyVault resource. | `'kv.id'`, `'/subscriptions/<subscription>/resourceGroups/<rg/providers/Microsoft.KeyVault/vaults/<keyvaultname>'`
| secrets | n | Map specify secret object name and secret properties. See [secret properties](#secrets) | <code>mysecret: {<br>name: 'mysecret'{<br>encoding: 'utf-8{<br>}</code>
| keys | n | Map specify key object name and key properties. See [key properties](#keys) | <code>mykey: {<br>name: 'mykey'<br>}</code>
| certificates | n | Map specify certificate object name and [certificate properties]. See [certificate properties](#certificate) | <code>mycert: {<br>name: 'mycert'<br>value: 'certificate'<br>}</code>

#### Secrets

| Key  | Description | Required | Example |
|------|:------------|----------|---------|
| name | secret name in Azure Key Vault | true | `'mysecret'`
| version | specific secret version. Default is latest | false | `'1234'`
| encoding | encoding format 'utf-8', 'hex', 'base64'. Default is 'utf-8' | false | `'bas64'`
| alias | file name created on the disk. Same as objectname if not specified | false | `'my-secret'`

#### Keys

| Key  | Description | Required | Example |
|------|:------------|----------|---------|
| name | key name in Azure Key Vault | true | `'mykey'`
| version | specific key version. Default is latest | false | `'1234'`
| alias | file name created on the disk. Same as objectname if not specified | false | `'my-key'`

#### Certificates

| Key  | Description | Required | Example |
|------|:------------|----------|---------|
| name | certificate name in Azure Key Vault | true | `'mycert'`
| value | value to download from Azure Key Vault 'privatekey', 'publickey' or 'certificate' | true | `'certificate'`
| version | specific certificate version. Default is latest | false | `'1234'`
| encoding | encoding format 'utf-8', 'hex', 'base64'. Default is 'utf-8' and this field can be specificed only when value is 'privatekey' | false | `'bas64'`
| alias | file name created on the disk. Same as objectname if not specified | false | `'my-cert'`
| format | certificate format 'pfx', 'pem'. Default is 'pfx' | false | `'my-cert'`
