---
type: docs
title: "Quickstart: Mount a Key vault as a volume to a container"
linkTitle: "Mount a Key vault as a volume"
description: "Learn how to mount an Azure Key vault as a volume to a container" 
weight: 700
slug: 'keyvault-wi'
---

This quickstart will provide an overview of how to:

- Setup a Radius environment with an identity provider
- Define a connection to an Azure resource with Azure AD role-based access control (RBAC) assignments
- Leverage Azure managed identities to connect to an Azure resource
- Mount a Key vault as a volume to a container

## Prerequisites

- [rad CLI]({{< ref getting-started >}})
- [Supported Kubernetes cluster]({{< ref kubernetes >}}) deployed with [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) installed

## Step 1: Run `rad env init kubernetes` 

Begin by running [`rad env init kubernetes`]({{< ref rad_env_init_kubernetes >}}). Make sure to configure an Azure cloud provider:

 ```bash
   rad env init kubernetes -i
   ```

## Step 2: Define a Radius environment

Create a file named `app.bicep` and define a Radius environment with the identity property set:

{{< rad file="snippets/keyvault-wi-1.bicep" embed=true >}}

## Step 3: Define an app, container, Key vault, and volume

1. Add a Radius application, [container]({{< ref container >}}), and Key vault to your `app.bicep` file. Then, mount a volume to your container:

{{< rad file="snippets/Key vault-wi-2.bicep" embed=true marker="//CONTAINER" >}}

2. Then, add a Key vault and mount a volume to your container:

{{< rad file="snippets/keyvault-wi-2.bicep" embed=true marker="//VOLUME" >}}


## Step 4: Deploy the app

Deploy your app by specifying the OIDC issuer URL. To retrieve the OIDC issuer URL, follow the Azure Workload Identity installation guide.

```bash
   rad deploy ./app.bicep -p oidcIssuer=${OIDC_ISSUER_URL}
   ```

## Step 5: Verify access to the Key vault

1. Once deployment completes, read the logs from your running container resource:

```bash
   rad resource logs containers mycontainers -a myapp
   ```

2. You should see the contents of the `/var/secrets` mount path defined in your `app.bicep` file:

```txt
[myapp-mycontainer-84bf87d96f-scb2t] mysecret
```

## Cleanup

1. Run the following command to delete your app and container:

```bash
   rad app delete myapp --yes
   ```
