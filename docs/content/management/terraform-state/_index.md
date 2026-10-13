---
type: docs
title: "How to configure Terraform state storage"
linkTitle: "Configure Terraform state"
description: "Configure existing S3 or Azure Blob storage for Terraform recipe state in a new Environment"
weight: 250
---

Radius tracks the infrastructure provisioned by each Terraform recipe in a separate Terraform state. By default, Radius stores this state in Kubernetes secrets. You can instead configure an existing AWS S3 bucket or Azure Blob container through `Radius.Core/terraformSettings`.

This guide describes the cloud backend support in the Radius edge build. Use matching CLI, control plane, and Bicep extension versions that include this feature; do not assume it is available in an older released installation.

| Backend | Configuration | Storage to provision before deployment |
| --------- | --------------- | ---------------------------------------- |
| Kubernetes | Omit `backend` | Radius manages state secrets in its Kubernetes cluster. |
| S3 | `backend.type: 's3'` | An S3 bucket in the specified AWS region. |
| Azure Blob | `backend.type: 'azurerm'` | An Azure storage account and blob container. |

{{% alert title="Choose the backend before deploying applications" color="warning" %}}
Cloud backends are supported for **new Environments only**. Configure the backend when creating TerraformSettings, then reference those settings from the new Environment. You cannot change the backend later or add one to existing settings, even if they have never been used.

Radius cannot migrate or adopt existing Terraform state. Replacing settings or changing an existing deployment's settings reference can leave infrastructure that Radius can no longer manage. The control plane does not block every unsafe change.
{{% /alert %}}

## Before you begin

- Install a Radius build with cloud backend support and configure the [Radius Bicep extension]({{< ref "/installation/dev-workstation#configure-bicepconfigjson" >}}) used by your deployment.
- Choose a new Environment name and create its Kubernetes namespace before deploying the Environment. The namespace must not be assigned to another Environment.
- Provision the backend storage using your organization's cloud provisioning process. Radius does not create the bucket, storage account, or container.
- [Register cloud credentials]({{< ref "/installation/cloud-providers" >}}) in Radius and grant them the state-storage permissions below. S3 supports AccessKey and IRSA; Azure supports ServicePrincipal and Workload Identity. Identity-based credentials also require the token projection and federation described in their installation guides.
- Have a [Recipe Pack]({{< ref "/management/recipe-packs" >}}) containing the Terraform recipes you intend to run. Backend storage is independent of where a recipe provisions infrastructure: a Kubernetes-only recipe can use S3 state and still requires registered AWS credentials.

Registry tokens under `terraformrc.credentials` authenticate module downloads, not access to backend storage. Do not put cloud credentials in the `backend` object.

### Grant storage permissions

Grant the **default credential registered in Radius for the selected cloud** access to the storage:

| Backend | Required permissions |
| --- | --- |
| S3 | `s3:ListBucket` on the bucket, scoped to the state prefix as appropriate; `s3:GetObject`, `s3:PutObject`, and `s3:DeleteObject` on the state and lock objects under that prefix, for example `arn:aws:s3:::YOUR-BUCKET/YOUR-PREFIX/*`. Customer-managed encryption keys may require additional KMS permissions. |
| Azure Blob | **Storage Blob Data Contributor**, or equivalent blob read/write/delete/lease permissions, scoped to the container. Azure management-plane Contributor alone does not grant blob data access. Account-key lookup permission is not required. |

Delete permission is needed for state cleanup as well as lock handling. S3 uses native `.tflock` locking, not DynamoDB; Azure uses blob leases. Enable S3 versioning or Azure Blob soft delete according to your recovery policy.

{{% alert title="State storage is not an Environment isolation boundary" color="warning" %}}
Terraform state can contain sensitive values. Radius uses one registered default identity per cloud across the installation, not a separate backend identity per Environment or TerraformSettings resource. Separate prefixes or buckets do not isolate access from that shared principal. Use separate Radius installations with separately scoped credentials when you need independent state-access identities.
{{% /alert %}}

### Choose a state prefix

`keyPrefix` is required. Radius writes each resource's state at `<keyPrefix>/<40-character-resource-hash>.tfstate`. Updates use the same key; different resources have separate state objects.

Use distinct prefixes for Radius installations that share storage, such as `radius-installation-a/dev`. Otherwise, installations with the same resource identities can write to the same state object.

A prefix must contain 1–968 ASCII characters. Use letters, digits, underscores, or hyphens, with single slashes between segments. Do not use dots, spaces, or leading/trailing slashes. The length limit reserves room for the state filename and S3 lock suffix.

## Create settings and a new Environment

Choose **one** of the following examples and save it as `environment.bicep`. Replace the sample storage names, prefix, Environment name, namespace, and Recipe Pack name with your own values. The examples reference an existing Recipe Pack in the same Radius Resource Group.

### S3

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

### Azure Blob

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

These examples configure state storage, not cloud provisioning destinations for recipe resources. If your recipes provision AWS or Azure resources, also configure the appropriate Environment `providers` properties as described in [Manage Environments]({{< ref "/management/environments" >}}).

### Deploy the Environment definition

Create the namespace used by your chosen example in the Kubernetes cluster configured for the Environment. Confirm that your `kubectl` context targets that cluster first:

```bash
kubectl config current-context
kubectl create namespace dev-s3-state
```

For the Azure example, create `dev-azure-state` instead. Radius requires the namespace to exist when the Environment is created; declaring its name in Bicep does not create it.

Create a Radius Resource Group if needed, and ensure the referenced Recipe Pack exists there. If it does not, follow [Manage Recipe Packs]({{< ref "/management/recipe-packs#creating-a-new-recipe-pack" >}}) to prepare and deploy `recipe-pack.bicep` into this group before deploying the Environment. Its name must match `my-terraform-recipes` in the example, or you must update the example to match your pack.

```bash
rad group create state-demo
rad recipe-pack list --group state-demo
rad deploy environment.bicep --group state-demo
```

Read the settings back before deploying an application. For the S3 example:

```bash
rad resource show Radius.Core/terraformSettings s3-state-settings --group state-demo --output json
```

For Azure, use `azure-state-settings`. Confirm that `properties.backend` contains the type, storage location, and prefix you specified. If it is missing, stop and follow the [troubleshooting guidance](#troubleshoot-a-deployment) before deploying an application.

Deploy your application into the new Environment. For the S3 example:

```bash
rad deploy app.bicep --group state-demo --environment dev-s3-state
```

For the Azure example, use `--environment dev-azure-state`. The application must use Resource Types backed by Terraform recipes in the referenced Recipe Pack to exercise the backend; Bicep recipes do not use Terraform state.

Creating settings does not check access to the bucket or container. The first Terraform recipe deployment runs `terraform init`, which reports missing storage, permission, or connectivity errors.

After a successful deployment, use your cloud storage tool to check for `.tfstate` objects under the configured prefix. State can contain sensitive values; do not paste its contents into logs or support requests.

## Update settings and manage state

To update other TerraformSettings properties, such as registry configuration, include the unchanged `backend` object. Its type, storage location, region, and prefix cannot change. Both PUT and PATCH reject requests that omit or remove an existing backend.

After destroying a recipe's resources, Radius checks whether its state object is empty and attempts to delete it. Radius keeps state that still tracks resources, changes during cleanup, or cannot be verified as empty. If cleanup fails, Radius logs a warning but still completes the resource deletion.

**Radius never deletes the bucket, storage account, or container.** Versioning and soft-delete policies can retain earlier state versions.

For applications already using Kubernetes-backed state, create a new Environment with cloud-backed settings and redeploy the applications there. Verify the new deployments before deleting the old ones through their **original Environment and settings**. Keep the original state accessible until deletion finishes.

Both deployments exist temporarily. Plan separately for moving application data and traffic, especially for stateful services.

## Troubleshoot a deployment

| Symptom | What to check |
| --------- | --------------- |
| Deployment succeeds, but `properties.backend` is missing | An older control plane can discard fields it does not recognize. Check the running control-plane images and Bicep extension version. On a compatible installation, recreate the unused settings and Environment before deploying applications; do not try to add a backend to existing settings. |
| `terraform init` cannot find or access storage | Confirm the bucket region or storage account/container, network access from Radius, and permissions of the registered default credential. Azure role assignments may take time to propagate. |
| A settings update rejects the backend | Retain the exact backend object for unrelated changes. Do not try to switch an existing deployment to new storage; create a new Environment instead. |
| Execution rejects an endpoint or authentication variable | Remove the conflicting setting from TerraformSettings or the inherited Radius process environment. The rules below apply to both deploy and delete, so retry deletion only after removing the conflict. |
| A warning reports state left after destroy | Inspect the object and the warning before acting. Do not delete live, changed, or unrecognized state. For a failed cleanup of confirmed-empty state, check delete permissions and use the logged key to locate the leftover object. |

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
