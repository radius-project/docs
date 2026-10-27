---
type: docs
title: "How to configure Terraform state storage"
linkTitle: "Configure Terraform state"
description: "Configure existing S3 or Azure Blob storage for Terraform recipe state in a new Environment"
weight: 250
---

Radius tracks the infrastructure provisioned by each Terraform recipe in a separate Terraform state. By default, Radius stores this state in Kubernetes secrets. You can instead configure an existing AWS S3 bucket or Azure Blob container through `Radius.Core/terraformSettings`.

{{% alert title="Choose the backend before deploying applications" color="warning" %}}
Cloud backends are supported for **new Environments only**. Configure the backend when creating TerraformSettings, then reference those settings from the new Environment. You cannot change the backend later or add one to existing settings, even if they have never been used.

Radius cannot migrate or adopt existing Terraform state. Replacing Terraform settings or changing the settings referenced by an existing deployment can cause existing infrastructure to remain deployed but no longer be manageable by Radius. The control plane does not block every unsafe change.
{{% /alert %}}

## Before you begin

### Grant storage permissions

Grant the default [credential registered in Radius]({{< ref "/installation/cloud-providers" >}}) for the selected cloud access to the storage:

| Backend | Required permissions |
| --- | --- |
| S3 | `s3:ListBucket` on the bucket, scoped to the state prefix as appropriate; `s3:GetObject`, `s3:PutObject`, and `s3:DeleteObject` on the state and lock objects under that prefix, for example `arn:aws:s3:::YOUR-BUCKET/YOUR-PREFIX/*`. Customer-managed encryption keys may require additional KMS permissions. |
| Azure Blob | Storage Blob Data Contributor, or equivalent blob read/write/delete/lease permissions, scoped to the container. Azure management-plane Contributor alone does not grant blob data access. Account-key lookup permission is not required. |

{{% alert title="State storage is not an Environment isolation boundary" color="warning" %}}
Terraform state can contain sensitive values. Radius uses one registered default identity per cloud across the installation, not a separate backend identity per Environment or TerraformSettings resource. Separate prefixes or buckets do not isolate access from that shared principal. Use separate Radius installations with separately scoped credentials when you need independent state-access identities.
{{% /alert %}}

### Choose a state prefix

`keyPrefix` is required. Radius writes each resource's state at `<keyPrefix>/<40-character-resource-hash>.tfstate`. Updates use the same key; different resources have separate state objects.

Use distinct prefixes for Radius installations that share storage, such as `radius-installation-a/dev`. Otherwise, installations with the same resource identities can write to the same state object.

A prefix must contain 1–968 ASCII characters. Use letters, digits, underscores, or hyphens, with single slashes between segments. Do not use dots, spaces, or leading/trailing slashes. The length limit reserves room for the state filename and S3 lock suffix.

## Create settings and a new Environment

Choose the backend for your new Environment. For a cloud backend, provision the storage before deploying the settings:

| Backend | Configuration | Storage to provision before deployment |
| --------- | --------------- | ---------------------------------------- |
| Kubernetes | Omit `backend` | Radius manages state secrets in its Kubernetes cluster. |
| S3 | `backend.type: 's3'` | An S3 bucket in the specified AWS region. |
| Azure Blob | `backend.type: 'azurerm'` | An Azure storage account and blob container. |

Save the example for your cloud as `environment.bicep`. Replace the sample storage names, prefix, Environment name, namespace, and Recipe Pack name with your own values. The examples reference an existing Recipe Pack in the same Radius Resource Group.

{{< tabs "AWS S3" "Azure Blob" >}}

{{% codetab %}}

```bicep
extension radius

resource terraformState 'Radius.Core/terraformSettings@2025-08-01-preview' = {
  name: 's3-state-settings'
  properties: {
    backend: {
      type: 's3'
      bucket: 'your-existing-state-bucket'
      region: 'us-west-2'
      keyPrefix: 'radius-installation-a/dev'
    }
  }
}

resource recipes 'Radius.Core/recipePacks@2025-08-01-preview' existing = {
  name: 'my-terraform-recipes'
}

resource environment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'dev-s3-state'
  properties: {
    terraformSettings: terraformState.id
    recipePacks: [
      recipes.id
    ]
    providers: {
      kubernetes: {
        namespace: 'dev-s3-state'
      }
    }
  }
}
```

{{% /codetab %}}

{{% codetab %}}

```bicep
extension radius

resource terraformState 'Radius.Core/terraformSettings@2025-08-01-preview' = {
  name: 'azure-state-settings'
  properties: {
    backend: {
      type: 'azurerm'
      storageAccountName: 'yourstateaccount'
      containerName: 'tfstate'
      keyPrefix: 'radius-installation-a/dev'
    }
  }
}

resource recipes 'Radius.Core/recipePacks@2025-08-01-preview' existing = {
  name: 'my-terraform-recipes'
}

resource environment 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'dev-azure-state'
  properties: {
    terraformSettings: terraformState.id
    recipePacks: [
      recipes.id
    ]
    providers: {
      kubernetes: {
        namespace: 'dev-azure-state'
      }
    }
  }
}
```

Azure state access uses Microsoft Entra authentication, not storage account keys. The storage account name must contain 3–24 lowercase letters or digits. Use a valid Azure container name containing 3–63 lowercase letters, digits, or hyphens, starting and ending with a letter or digit.

{{% /codetab %}}

{{< /tabs >}}

These examples configure state storage, not cloud provisioning destinations for recipe resources. If your recipes provision AWS or Azure resources, also configure the appropriate Environment `providers` properties as described in [Manage Environments]({{< ref "/management/environments" >}}).

### Deploy the Environment definition

Create the namespace used by your chosen example in the Kubernetes cluster configured for the Environment. Use a namespace that is not assigned to another Environment, and confirm that your `kubectl` context targets the correct cluster:

{{< tabs "AWS S3" "Azure Blob" >}}

{{% codetab %}}

```bash
kubectl config current-context
kubectl create namespace dev-s3-state
```

{{% /codetab %}}

{{% codetab %}}

```bash
kubectl config current-context
kubectl create namespace dev-azure-state
```

{{% /codetab %}}

{{< /tabs >}}

Create a Radius Resource Group if needed, and ensure the referenced Recipe Pack exists there. If it does not, follow [Manage Recipe Packs]({{< ref "/management/recipe-packs#creating-a-new-recipe-pack" >}}) to prepare and deploy `recipe-pack.bicep` into this group before deploying the Environment. Its name must match `my-terraform-recipes` in the example, or you must update the example to match your pack.

```bash
rad group create state-demo
rad recipe-pack list --group state-demo
rad deploy environment.bicep --group state-demo
```

### Verify the settings

Read the settings back and confirm that `properties.backend` contains the type, storage location, and prefix you specified:

{{< tabs "AWS S3" "Azure Blob" >}}

{{% codetab %}}

```bash
rad resource show Radius.Core/terraformSettings s3-state-settings --group state-demo --output json
```

{{% /codetab %}}

{{% codetab %}}

```bash
rad resource show Radius.Core/terraformSettings azure-state-settings --group state-demo --output json
```

{{% /codetab %}}

{{< /tabs >}}

If `properties.backend` is missing, follow the [troubleshooting guidance](#troubleshoot-a-deployment) before deploying an application.

### Deploy an application

Deploy an application that uses Resource Types backed by Terraform recipes in the referenced Recipe Pack:

{{< tabs "AWS S3" "Azure Blob" >}}

{{% codetab %}}

```bash
rad deploy app.bicep --group state-demo --environment dev-s3-state
```

{{% /codetab %}}

{{% codetab %}}

```bash
rad deploy app.bicep --group state-demo --environment dev-azure-state
```

{{% /codetab %}}

{{< /tabs >}}

After deployment, use your cloud storage tool to check for `.tfstate` objects under the configured prefix.

## Update settings and manage state

### Update other Terraform settings

To change registry configuration or other TerraformSettings properties, include the unchanged `backend` object in the update. Both PUT and PATCH require it.

### Delete resources and clean up state

Delete deployments through their original Environment and settings, keeping the state accessible until deletion finishes. After destroying a recipe's resources, Radius attempts to delete the empty state object. It preserves state that still tracks resources or outputs, changes during cleanup, or cannot be verified as empty. Cleanup failures are logged and do not fail resource deletion.

Radius leaves the bucket, storage account, and container for you to manage. Versioning and soft-delete policies can retain earlier state versions.

### Redeploy applications with a different backend

Create a new Environment with new TerraformSettings and redeploy the applications there. Plan for both deployments to coexist while you move application data and traffic. Verify the new deployments before deleting the old ones through their original Environment and settings.

## Troubleshoot a deployment

| Symptom | What to check |
| --------- | --------------- |
| Deployment succeeds, but `properties.backend` is missing | An older control plane can discard fields it does not recognize. Check the running control-plane images and Bicep extension version. On a compatible installation, recreate the unused settings and Environment before deploying applications; do not try to add a backend to existing settings. |
| `terraform init` cannot find or access storage | Confirm the bucket region or storage account/container, network access from Radius, and permissions of the registered default credential. Azure role assignments may take time to propagate. |
| A settings update rejects the backend | Retain the exact backend object for unrelated changes. Do not try to switch an existing deployment to new storage; create a new Environment instead. |
| Execution rejects an endpoint or authentication variable | Remove the conflicting setting from TerraformSettings or the inherited Radius process environment. The rules below apply to both deploy and delete, so retry deletion only after removing the conflict. |
| A log message reports state left after destroy | Inspect the object and the log message before acting. Do not delete live, changed, or unrecognized state. For a failed cleanup of confirmed-empty state, check delete permissions and use the logged key to locate the leftover object. |

### AWS endpoint overrides

Managed S3 state supports AWS endpoints, not custom S3-compatible endpoints. Remove nonempty values for the following variables:

| Endpoint | Rejected variables |
| --- | --- |
| All AWS services | `AWS_ENDPOINT_URL` |
| S3 | `AWS_ENDPOINT_URL_S3`, `AWS_S3_ENDPOINT` |
| STS | `AWS_ENDPOINT_URL_STS`, `AWS_STS_ENDPOINT` |

These checks apply even when `AWS_IGNORE_CONFIGURED_ENDPOINT_URLS=true`. Shared AWS configuration cannot override the backend's selected identity or endpoint.

### Azure authentication conflicts

For Azure Workload Identity, remove nonempty values for these variables. They conflict with the registered backend identity:

| Authentication method | Rejected variables |
| --- | --- |
| Storage key or SAS token | `ARM_ACCESS_KEY`, `ARM_SAS_TOKEN` |
| Client certificate | `ARM_CLIENT_CERTIFICATE`, `ARM_CLIENT_CERTIFICATE_PATH`, `ARM_CLIENT_CERTIFICATE_PASSWORD` |
| Client secret | `ARM_CLIENT_SECRET`, `ARM_CLIENT_SECRET_FILE_PATH` |
| Client ID file | `ARM_CLIENT_ID_FILE_PATH` |
| OIDC token | `ARM_OIDC_TOKEN` |

Both ServicePrincipal and Workload Identity reject nonempty `ARM_METADATA_HOSTNAME` and `ARM_METADATA_HOST`. Use `ARM_ENVIRONMENT` to select a supported Azure cloud instead.

### Provider credentials

With AccessKey or ServicePrincipal, recipe providers that read credentials from environment variables can also use the backend's identity. Configure provider credentials explicitly if they must differ.

IRSA and Workload Identity configure backend authentication separately and leave the providers' environment unchanged. The conflict checks above still apply.

## Next steps

See the [TerraformSettings reference]({{< ref "/reference/resources/radius.core/2025-08-01-preview/terraformsettings" >}}) for the API schema and other engine settings, and [Manage Recipe Packs]({{< ref "/management/recipe-packs" >}}) to configure the recipes your Environment uses.
