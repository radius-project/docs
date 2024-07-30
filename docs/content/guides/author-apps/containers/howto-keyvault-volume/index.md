---
type: docs
title: "How-To: Mount an Azure Key Vault as a volume to a container"
linkTitle: "Mount a Key Vault"
description: "Learn how to mount an Azure Key Vault as a volume to a container"
weight: 600
slug: 'volume-keyvault'
categories: "How-To"
tags: ["Azure","containers"]
---

This how-to guide will provide an overview of how to:

- Setup a Radius Environment with an identity provider
- Define a connection to an Azure resource with Azure AD role-based access control (RBAC) assignments
- Leverage Azure managed identities to connect to an Azure resource
- Mount a Key vault as a volume to a container

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [`bicepconfig.json`]({{< ref "/shared-content/installation/bicepconfig/generate-bicep-config.md" >}})
- [Supported Kubernetes cluster]({{< ref "guides/operations/kubernetes" >}})
- [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) installed on your cluster
- [Azure Keyvault Provider](https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/getting-started/installation/)
  - The above installation will also install the required [Secrets Store CSI Driver](https://secrets-store-csi-driver.sigs.k8s.io/getting-started/installation.html)

## Step 1: Initialize Radius

Begin by running [`rad init --full`]({{< ref rad_init >}}). Make sure to configure an Azure cloud provider:

```bash
rad init --full
```

## Step 2: Define a Radius Environment

Create a file named `app.bicep` and define a Radius Environment with the identity property set:

{{< rad file="snippets/keyvault-wi.bicep" embed=true marker="//ENVIRONMENT">}}

## Step 3: Define an app, Key  Vault, and volume

Add a Radius Application, an Azure Key Vault, and a Radius volume which uses the Key Vault to your `app.bicep` file:

{{< rad file="snippets/keyvault-wi.bicep" embed=true marker="//APP" >}}

## Step 4: Define an app, Key  Vault, and volume

Now add a Radius [container]({{< ref "guides/author-apps/containers" >}}) with a volume mount for the Radius volume:

{{< rad file="snippets/keyvault-wi.bicep" embed=true marker="//CONTAINER" >}}

## Step 5: Deploy the app

Deploy your app, specifying the OIDC issuer URL. To retrieve the OIDC issuer URL, follow the [Azure Workload Identity installation guide](https://azure.github.io/azure-workload-identity/docs/installation.html).

```bash
rad deploy ./app.bicep -p oidcIssuer=<OIDC_ISSUER_URL>
```

## Step 6: Verify access to the mounted Azure Key Vault

1. Once deployment completes, read the logs from your running container resource:

   ```bash
   rad resource logs containers mycontainer -a myapp
   ```

1. You should see the contents of the `/var/secrets` mount path defined in your `app.bicep` file:

   ```
   [myapp-mycontainer-d8b4fc44-qrhnn] secret context : supersecret
   ```

   Note: You might need to wait 1-2 minutes for the pods and identities to be set up completely. Retry in a few minutes if you are unable to view the secret contents.

## Cleanup

1. Run the following command to delete your app and container:

   ```bash
   rad app delete myapp --yes
   ```
   
1. Delete the deployed Azure Key Vault via the Azure portal or the Azure CLI
