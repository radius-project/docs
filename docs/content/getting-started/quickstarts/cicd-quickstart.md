---
type: docs
title: "Quickstart: CI/CD integration"
linkTitle: "CI/CD pipelines"
description: "Learn about adding your Radius apps to your deployment pipelines" 
weight: 500
---

It's easy to get Project Radius added to your deployment pipelines.

## Prerequisites

- [az CLI](https://aka.ms/azcli) (only if deploying Azure resources)
- Kubernetes cluster (AKS, EKS, GKE, etc.)

## Step 1: Create an Azure Service Principal

An Azure service principal is required if you are deploying Azure resources as part of your application with the [Azure cloud provider]({{< ref providers >}}). If your application does not use Azure resources, you can skip this step.

1. Run the following command, making sure to change the values of `subscriptionId` and `resourceGroupName` to match your target scope.

   ```bash
   az ad sp create-for-rbac -n "GitHub Deploy SP" --scopes /subscriptions/{subscriptionId} --role contributor --sdk-auth
   ```
   
1. Take the output of the above command and paste it into a [GitHub secret](https://docs.github.com/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository) named `AZURE_CREDENTIALS`.

## Step 2: Create a workflow file

### Basics

Create a new file named `deploy-radius.yml` under `.github/workflows/` and paste the following:

```yml
name: Deploy Radius app
on:
  push:
    branches:
      - main
env:
  RADIUS_INSTALL_DIR: ./

jobs:
  deploy:
    name: Deploy app
    runs-on: ubuntu-latest
    steps:
    - name: Check out repo
      uses: actions/checkout@v2
    - name: Setup kubectl
      uses: azure/setup-kubectl@v1
```

### Download kubectl context

To interact with the cluster, the rad CLI requires a valid kubectl context.

{{< tabs AKS >}}

{{% codetab %}}
Ensure the service principal created above has the proper RBAC assignment to download the AKS context:
```yml
    - name: az Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
    - name: Configure kubectl context
      run: az aks get-credentials --name ${CLUSTER} --resource-group ${RESOURCE_GROUP} --subscription ${SUBSCRIPTION_ID}
```
{{% /codetab %}}

{{< /tabs >}}

### Download rad CLI and connect to environment

```yml
    - name: Download rad CLI and rad-bicep
      run: |
        wget -q "https://get.radapp.dev/tools/rad/install.sh" -O - | /bin/bash
        ./rad bicep download
        ./rad --version
    - name: Initialize Radius environment
      run: ./rad env init kubernetes -n ${NAMESPACE}
```

### Deploy application

Finally, run the `rad deploy` app to deploy your application. If the application had been previously deployed, it will be updated.

```yml
    - name: Deploy app
      run: ./rad deploy ./iac/app.bicep
```