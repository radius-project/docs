---
type: docs
title: "Quickstart: Connect a container to an Azure resource"
linkTitle: "Connect to Azure resources"
description: "Learn how to connect a container to an Azure resource with managed identities and RBAC" 
weight: 600
slug: 'azure-connection'
---

This quickstart will provide an overview of how to:

- Setup a Radius environment with an identity provider
- Define a connection to an Azure resource with Azure AD role-based access control (RBAC) assignments
- Leverage Azure managed identities to connect to an Azure resource

The steps below will showcase a "rad-ified" version of the existing [Azure AD workload identity quickstart](https://azure.github.io/azure-workload-identity/docs/quick-start.html).

## Prerequisites

- [rad CLI]({{< ref getting-started >}}) installed on your machine
- [Supported Kubernetes cluster]({{< ref kubernetes >}}) deployed with [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) installed

## Step 1: Run `rad env init kubernetes` 

Begin by running [`rad env init kubernetes`]({{< ref rad_env_init_kubernetes >}}). Make sure to configure an Azure cloud provider:

 ```bash
   rad env init kubernetes -i
   ```

## Step 2: Define a Radius environment 

Create a file named `app.bicep` and define a Radius environment with the identity property set:

{{< rad file="snippets/container-wi-1.bicep" embed=true >}}

## Step 3: Define an app and a container

Add a Radius application, [container]({{< ref container >}}), and Key vault to your `app.bicep` file:

{{< rad file="snippets/container-wi-2.bicep" embed=true marker="//CONTAINER" >}}

## Step 4: Deploy the app and container

Deploy your app by specifying the OIDC issuer URL. To retrieve the OIDC issuer URL, follow the Azure Workload Identity installation guide.

```bash
   rad deploy ./app.bicep -p oidcIssuer=<OIDC_ISSUER_URL>
   ```

## Step 5: Verify access to the Key vault

1. Once deployment completes, read the logs from your running container resource:

```bash
   rad resource logs containers mycontainers -a myapp
   ```

2. You should see the contents of the secret defined in your `app.bicep` file:

```txt
[myapp-mycontainer-79c54bd7c7-tgdpn] I1108 18:39:53.636314       1 main.go:33] "successfully got secret" secret="supersecret"
```

## Cleanup

Run the following command to delete your app and container:

```bash
   rad app delete myapp --yes
   ```
