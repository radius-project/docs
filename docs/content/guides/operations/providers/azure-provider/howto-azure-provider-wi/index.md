---
type: docs
title: "How-To: Configure the Azure cloud provider with Azure workload identity"
linkTitle: "Azure provider with Workload identity"
description: "Learn how to configure the Azure provider with Azure workload identity for your Radius Environment"
weight: 200
categories: "How-To"
tags: ["Azure"]
---

The Azure provider allows you to deploy and connect to Azure resources from a self-hosted Radius Environment. It can be configured:

- [Interactively via `rad init`](#interactive-configuration)
- [Manually via `rad env update` and `rad credential register`](#manual-configuration)

## Prerequisites

- [Azure subscription](https://azure.com)
- [az CLI](https://aka.ms/azcli)
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Setup a supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
  - You will need the cluster's OIDC Issuer URL. [AKS Example](https://azure.github.io/azure-workload-identity/docs/installation/managed-clusters.html#azure-kubernetes-service-aks)
- [Azure AD Workload Identity](https://azure.github.io/azure-workload-identity/docs/installation.html) installed in your cluster, including the [Mutating Admission Webhook](https://azure.github.io/azure-workload-identity/docs/installation/mutating-admission-webhook.html)

## Setup

To authorize Radius with Azure using Azure workload identity, you should set up an Entra ID Application with access to your resource group of choosing and 3 federated credentials (one for each of the Radius services). Below is an example script that will create an Entra ID Application and set up the federated credentials necessary for Radius to authenticate with Azure using Azure workload identity.

### install-radius-azwi.sh
```sh
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <K8S_CLUSTER_NAME> <AZURE_RESOURCE_GROUP> <AZURE_SUBSCRIPTION_ID> <OIDC_ISSUER_URL>"
    exit 1
fi

export K8S_CLUSTER_NAME=$1
export AZURE_RESOURCE_GROUP=$2
export AZURE_SUBSCRIPTION_ID=$3
export SERVICE_ACCOUNT_ISSUER=$4

# Create the Entra ID Application
export APPLICATION_NAME="${K8S_CLUSTER_NAME}-radius-app"
az ad app create --display-name "${APPLICATION_NAME}"

# Get the client ID and object ID of the application
export APPLICATION_CLIENT_ID="$(az ad app list --display-name "${APPLICATION_NAME}" --query [].appId -o tsv)"
export APPLICATION_OBJECT_ID="$(az ad app show --id "${APPLICATION_CLIENT_ID}" --query id -otsv)"

# Create the applications-rp federated credential for the application
cat <<EOF > params-applications-rp.json
{
  "name": "radius-applications-rp",
  "issuer": "${SERVICE_ACCOUNT_ISSUER}",
  "subject": "system:serviceaccount:radius-system:applications-rp",
  "description": "Kubernetes service account federated credential for applications-rp",
  "audiences": [
    "api://AzureADTokenExchange"
  ]
}
EOF
az ad app federated-credential create --id "${APPLICATION_OBJECT_ID}" --parameters @params-applications-rp.json

# Create the bicep-de federated credential for the application
cat <<EOF > params-bicep-de.json
{
  "name": "radius-bicep-de",
  "issuer": "${SERVICE_ACCOUNT_ISSUER}",
  "subject": "system:serviceaccount:radius-system:bicep-de",
  "description": "Kubernetes service account federated credential for bicep-de",
  "audiences": [
    "api://AzureADTokenExchange"
  ]
}
EOF
az ad app federated-credential create --id "${APPLICATION_OBJECT_ID}" --parameters @params-bicep-de.json

# Create the ucp federated credential for the application
cat <<EOF > params-ucp.json
{
  "name": "radius-ucp",
  "issuer": "${SERVICE_ACCOUNT_ISSUER}",
  "subject": "system:serviceaccount:radius-system:ucp",
  "description": "Kubernetes service account federated credential for ucp",
  "audiences": [
    "api://AzureADTokenExchange"
  ]
}
EOF
az ad app federated-credential create --id "${APPLICATION_OBJECT_ID}" --parameters @params-ucp.json

# Set the permissions for the application
az ad sp create --id ${APPLICATION_CLIENT_ID}
az role assignment create --assignee "${APPLICATION_CLIENT_ID}" --role "Owner" --scope "/subscriptions/${AZURE_SUBSCRIPTION_ID}/resourceGroups/${AZURE_RESOURCE_GROUP}"
```

Now that the setup is complete, you can now install Radius with Azure workload identity enabled.

## Interactive configuration

1. Initialize a new environment with [`rad init --full`]({{< ref rad_init >}}):

   ```bash
   rad init --full
   ```

1. Follow the prompts, specifying:
   - **Namespace** - The Kubernetes namespace where your application containers and networking resources will be deployed (different than the Radius control-plane namespace, `radius-system`)
   - **Add an Azure provider** 
      1. Pick the subscription and resource group to deploy your Azure resources to.
      2. Select the "Workload Identity" option
      3. Enter the `appId` and the `tenantID` of the Entra ID Application
   - **Environment name** - The name of the environment to create

   You should see the following output:

      ```
      Initializing Radius...

      ✅ Install Radius {{< param version >}}
         - Kubernetes cluster: k3d-k3s-default
         - Kubernetes namespace: radius-system
         - Azure credential: WorkloadIdentity                                                       
         - Client ID: **********
      ✅ Create new environment default
         - Kubernetes namespace: default
         - Azure: subscription ***** and resource group ***
      ✅ Scaffold application samples
      ✅ Update local configuration

      Initialization complete! Have a RAD time 😎
      ```

## Manual configuration


1. Use [`rad install kubernetes`]({{< ref rad_install_kubernetes >}}) to install Radius with Azure workload identity enabled:

    ```bash
    rad install kubernetes --set global.azureWorkloadIdentity.enabled=true
    ```

1. Create your resource group and environment:

    ```bash
    rad group create default
    rad env create default
    ```

1. Use [`rad env update`]({{< ref rad_env_update >}}) to update your Radius Environment with your Azure subscription ID and Azure resource group:

    ```bash
    rad env update myEnvironment --azure-subscription-id myAzureSubscriptionId --azure-resource-group  myAzureResourceGroup
    ```

1. Use [`rad credential register azure wi`]({{< ref rad_credential_register_azure_wi >}}) to add the Azure workload identity credentials:

    ```bash
    rad credential register azure wi --client-id myClientId --tenant-id myTenantId
    ```

    Radius will use the provided client-id for all interactions with Azure, including Bicep and Recipe deployments.
