---
type: docs
title: "How to configure Azure credentials using workload identity"
linkTitle: "Azure Workload Identity"
description: "Learn how to configure Azure credentials using workload identity in the Radius control plane"
weight: 400
aliases:
  - /guides/installation/cloud-providers/azure/workload-identity/
---

Azure workload identity lets Radius deploy and connect to Azure resources without storing secrets by federating Kubernetes service account tokens with an Entra ID application. This guide sets up workload identity and registers it as an Azure credential in the Radius control plane.

## Before you begin

Before configuring workload identity, verify that:

- [A supported Kubernetes cluster]({{< ref "/installation#supported-kubernetes-clusters" >}}) with its OIDC issuer URL is available. See the [AKS example](https://azure.github.io/azure-workload-identity/docs/installation/managed-clusters.html#azure-kubernetes-service-aks).
- [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) is installed in the cluster, including the [Mutating Admission Webhook](https://azure.github.io/azure-workload-identity/docs/installation/mutating-admission-webhook.html).

## Step 1: Set up Azure workload identity

To authorize Radius to connect to Azure using workload identity, set up an Entra ID application with access to your resource group. Using the OIDC issuer for your Kubernetes cluster, create one federated credential for each Radius service (`applications-rp`, `bicep-de`, `ucp`, and `dynamic-rp`) in the `radius-system` namespace.

The following script creates an Entra ID application and the federated credentials Radius needs to authenticate with Azure using workload identity:

{{< rad file="snippets/install-radius-azwi.sh" embed=true lang=bash >}}

Record the application's client ID (`appId`) and tenant ID (`tenant`).

## Step 2a: Interactively via `rad initialize`

If Radius has not been installed already, [`rad initialize --full`]({{< ref rad_initialize >}}) can be used to interactively install Radius and configure Azure workload identity at the same time.

<!-- TODO: Remove the `--preview` flag from `rad initialize --full` below once it is no longer required. -->
```bash
rad initialize --full --preview
```

Follow the prompts:

1. When prompted with **"Add cloud providers for cloud resources?"**, select **Yes**.
1. Select **Azure**, then **Workload Identity**.
1. Enter the **client ID** (`appId`) and **tenant ID** recorded in [Step 1](#step-1-set-up-azure-workload-identity).
1. Enter the **Azure subscription ID** and **resource group** to use for the `default` Environment. The resource group must already exist.

## Step 2b: Manual configuration

Workload identity must be enabled on the Radius control plane. If Radius has not been installed, enable it by installing Radius with the `global.azureWorkloadIdentity.enabled` Helm value set to `true`:

```bash
rad install kubernetes --set global.azureWorkloadIdentity.enabled=true
```

If Radius is already installed, enable workload identity with an upgrade instead of reinstalling. This restarts the Radius control plane pods with the token mounted:

```bash
rad upgrade kubernetes --set global.azureWorkloadIdentity.enabled=true
```

Then create the Azure credential in the Radius control plane with [`rad credential register azure wi`]({{< ref rad_credential_register_azure_wi >}}):

```bash
rad credential register azure wi --client-id myClientId --tenant-id myTenantId
```

Radius will use the provided client ID for all interactions with Azure.

## Step 3: Update existing Environments

If you have existing Environments, you must also update your Environments with your Azure subscription ID and resource group:

<!-- TODO: Remove the `--preview` flag from `rad environment` below once it is no longer required. -->
```bash
rad environment update myEnvironment \
  --azure-subscription-id myAzureSubscriptionId \
  --azure-resource-group myAzureResourceGroup \
  --preview
```

This command updates the configuration of an environment for properties that are able to be changed. For more information visit [`rad environment update`]({{< ref rad_environment_update >}}).

## Next steps

Once AWS or Azure credentials are configured, set up access to the Radius Dashboard.

{{< button text="Next step: How to configure access to the Radius dashboard" page="installation/dashboard" >}}
