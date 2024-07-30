---
type: docs
title: "How-To: Connect a container to an Azure resource"
linkTitle: "Deploy Azure resources"
description: "Learn how to connect a container to an Azure resource with managed identities and RBAC"
weight: 600
slug: 'azure-connection'
categories: "How-To"
tags: ["Azure","containers"]
---

This how-to guide will provide an overview of how to:

- Setup a Radius Environment with an identity provider
- Define a connection to an Azure resource with Azure AD role-based access control (RBAC) assignments
- Leverage Azure managed identities to connect to an Azure resource

The steps below will showcase a "rad-ified" version of the existing [Azure AD workload identity quickstart](https://azure.github.io/azure-workload-identity/docs/quick-start.html).

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [`bicepconfig.json`]({{< ref "/shared-content/installation/bicepconfig/generate-bicep-config/index" >}})
- [Setup a supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
- [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) installed in your cluster, including the [Mutating Admission Webhook](https://azure.github.io/azure-workload-identity/docs/installation/mutating-admission-webhook.html)

## Step 1: Initialize Radius

Begin by running [`rad init --full`]({{< ref rad_init >}}). Make sure to configure an Azure cloud provider:

```bash
rad init --full
```

## Step 2: Define a Radius Environment

Create a file named `app.bicep` and define a Radius Environment with [identity property]({{< ref "/guides/deploy-apps/environments/overview" >}}) set. This configures your environment to use your Azure AD workload identity installation with your cluster's OIDC endpoint:

{{< rad file="snippets/container-wi.bicep" embed=true marker="//ENVIRONMENT">}}

## Step 3: Define an app and a container

Add a Radius Application, a Radius [container]({{< ref "guides/author-apps/containers" >}}), and an Azure Key Vault to your `app.bicep` file. Note the connection from the container to the Key Vault, with an iam property set for the Azure AD RBAC role:

{{< rad file="snippets/container-wi.bicep" embed=true marker="//CONTAINER" >}}

## Step 4: Deploy the app and container

Deploy your app by specifying the OIDC issuer URL. To retrieve the OIDC issuer URL, follow the [Azure Workload Identity installation guide](https://azure.github.io/azure-workload-identity/docs/installation.html).

```bash
rad deploy ./app.bicep -p oidcIssuer=<OIDC_ISSUER_URL>
```

## Step 5: Verify access to the Key Vault

1. Once deployment completes, read the logs from your running container resource:

   ```bash
   rad resource logs containers mycontainer -a myapp
   ```

1. You should see the contents of the secret from your Key Vault:

   ```txt
   [myapp-mycontainer-79c54bd7c7-tgdpn] I1108 18:39:53.636314       1 main.go:33] "successfully got secret" secret="supersecret"
   ```

   Note: the container retrieves the secret every 60 seconds. If you get an error on the first attempt, wait a minute and try again. The Azure AD federation may still be in progress.

## Cleanup

1. Run the following command to delete your app and container:

   ```bash
   rad app delete myapp --yes
   ```

1. Delete the deployed Azure Key Vault via the Azure portal or the Azure CLI
