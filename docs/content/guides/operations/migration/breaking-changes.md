---
type: docs
title: "Breaking changes: compute extensibility"
linkTitle: "Breaking changes"
description: "Enumerated breaking changes between the legacy Radius architecture and the compute extensibility model"
weight: 100
categories: "Reference"
tags: ["extensibility", "migration"]
---

This page enumerates the breaking changes introduced by the [compute extensibility]({{< ref "concepts/compute-extensibility" >}}) work. It is the companion reference to the [migration guide]({{< ref "guides/operations/migration" >}}).

> Compute extensibility resources use the `2025-08-01-preview` API version. Behaviour and schemas may continue to evolve until the APIs are promoted to stable.

## API namespace and versions

- New resources live under `Radius.*` (e.g. `Radius.Core/environments`, `Radius.Core/recipePacks`, `Radius.Compute/containers`, `Radius.Security/secrets`).
- The legacy `Applications.*` namespace (`Applications.Core/*`, `Applications.Datastores/*`, `Applications.Messaging/*`) remains available during migration but should be considered deprecated.
- The new preview API version is `2025-08-01-preview`. The legacy `2023-10-01-preview` API version is unchanged.

**Mitigation:** Re-author Bicep files against the new types/API version. The migration guide includes side-by-side examples.

## Environments are decomposed

The following properties of `Applications.Core/environments@2023-10-01-preview` are no longer present on `Radius.Core/environments@2025-08-01-preview`:

| Removed property                                          | Replacement                                                        |
|-----------------------------------------------------------|--------------------------------------------------------------------|
| `properties.recipes`                                      | One or more `Radius.Core/recipePacks` referenced via `properties.recipePacks` |
| `properties.recipeConfig.bicep.authentication`            | `Radius.Core/bicepSettings` referenced via `properties.bicepSettings` |
| `properties.recipeConfig.terraform.authentication`        | `Radius.Core/terraformSettings` `terraformrc.credentials`           |
| `properties.recipeConfig.terraform.providers`             | Recipe parameters that reference `Radius.Security/secrets` values   |
| `properties.recipeConfig.env`                             | `Radius.Core/terraformSettings` `properties.env`                    |
| `properties.compute.kind` (hard-coded `kubernetes`)       | Compute Resource Types from the Environment's Recipe Packs          |

**Mitigation:** Author Recipe Packs, BicepSettings, and TerraformSettings resources first, then re-create the Environment as a thin reference to them. See the migration guide.

## Compute is no longer hard-coded

`Applications.Core/containers`, `Applications.Core/gateways`, `Applications.Core/secretStores`, and similar built-ins are replaced by Recipe-backed Resource Types under `Radius.Compute/*`. The semantics are similar but the Recipe behind the type is now selected by the platform engineer rather than hard-coded into the Application RP.

**Mitigation:** Use Recipe Packs to publish a `Radius.Compute/containers` (etc.) Recipe. Reference implementations live in [`resource-types-contrib`](https://github.com/radius-project/resource-types-contrib).

## Terraform binary lifecycle

The Application RP no longer downloads Terraform on demand from `releases.hashicorp.com`. Terraform must be installed explicitly into the Radius control plane.

**Mitigation:**

```bash
rad terraform install                       # latest from hashicorp.com
rad terraform install --url <mirror-url> \
                      --checksum <sha256>   # pinned version from a mirror
```

Existing automation that assumed Terraform was always present without operator action must add a `rad terraform install` step.

## Custom Terraform providers

`recipeConfig.terraform.providers` (an arbitrary map injected into named providers) is removed. Provider credentials are now passed as **Recipe parameters** that reference `Radius.Security/secrets` values, and the Recipe declares the corresponding `var`s.

**Mitigation:** Update Recipes to declare `var datadog_api_key` (and similar) and update Recipe Pack entries to pass `parameters: { apiKey: secret.properties.data.apiKey.value }`. See the [TerraformSettings how-to]({{< ref "guides/recipes/howto-terraform-settings" >}}#step-4-inject-secrets-into-custom-terraform-providers).

## Terraform backends

The default Terraform backend is still `kubernetes`. Other backends are now configured via `Radius.Core/terraformSettings.properties.backend`:

- **Tier 1** (integrated authentication, tested): `kubernetes`, `s3`, `azurerm`.
- **Tier 2** (schema available, BYO authentication): `oss`, `consul`, `gcs`, `http`, `oci`, `pg`, `cos`.
- The Terraform `local` and `remote` backend types are not supported.

**Mitigation:** If you previously relied on the Kubernetes backend implicitly, no change is required. To use a different backend, declare it in TerraformSettings.

## Bicep registry authentication property names

The legacy schema used a registry-host → secret map. The new schema uses an `authenticationMethod` discriminator with named fields:

| `authenticationMethod` | Required field        |
|------------------------|-----------------------|
| `BasicAuth`            | `basicAuthSecretId`   |
| `AzureWI`              | `azureWiClientId`, `azureWiTenantId` |
| `AwsIrsa`              | `awsIamRoleArn`       |

**Mitigation:** Replace the registry-host → secret map with a single BicepSettings resource per Environment. The Azure WI client/tenant IDs and the AWS IAM role ARN are not stored as secret values.

## Secret resource changes

`Radius.Security/secrets` replaces `Applications.Core/secretStores`. The legacy `kind`/`type` discriminator (`basicAuthentication`, `azureWorkloadIdentity`, `awsIRSA`) is removed because the discriminator now lives on the BicepSettings resource. Secrets simply hold key/value data.

**Mitigation:** Re-create secrets without the `type` discriminator. For workload-identity and IRSA flows, supply the client/tenant/role identifiers directly to BicepSettings — they are not secrets.

## Deprecation timeline

The legacy `Applications.*` resource types and the `2023-10-01-preview` API version remain available so existing solutions are not broken at the moment compute extensibility lands. A formal deprecation timeline will be published once the `Radius.*` API version is promoted from preview to stable. Until then, plan to migrate but do not assume the legacy types will disappear in a specific release.

## Further reading

- [Compute extensibility concepts]({{< ref "concepts/compute-extensibility" >}})
- [Migration guide]({{< ref "guides/operations/migration" >}})
- [Extensibility design notes](https://github.com/radius-project/radius/tree/main/eng/design-notes/extensibility)
- [Terraform and Bicep settings feature spec](https://github.com/radius-project/design-notes/blob/main/features/2025-08-14-terraform-bicep-settings.md)
