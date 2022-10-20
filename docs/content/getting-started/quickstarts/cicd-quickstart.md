---
type: docs
title: "Quickstart: Github Actions CI/CD integration"
linkTitle: "GitHub Actions CI/CD"
description: "Learn about adding your Radius apps to your deployment pipelines" 
weight: 300
---

It's easy to get Project Radius added to your GitHub Actions deployment pipelines. By leveraging the `rad` CLI, you can keep your checked-in app definitions in sync with deployed instances of your app.

## Prerequisites

- [az CLI](https://aka.ms/azcli) (only if deploying Azure resources)
- Kubernetes cluster (AKS, EKS, GKE, etc.)

## Step 1: Create an Azure Service Principal

{{% alert title="Optional" color="warning" %}}
This step is only required if you are targeting an AKS cluster or if you are deploying Azure resources with the [Azure cloud provider]({{< ref providers >}}). If your application does not use Azure resources, you can skip this step.
{{% /alert %}}

An Azure service principal is used to authenticate with Azure both for accessing your AKS cluster (if applicable), and deploying resources into your subscription and resource group(s).

You can also optionally separate your service principals if you want to separately access your AKS cluster and deploy Azure resources with separate service principals.

1. Run the following command, making sure to change the values of `subscriptionId` to match your target scope. Note that an owner role is required in order to configure connections from containers to Azure resources.

   ```bash
   az ad sp create-for-rbac --scopes /subscriptions/{subscriptionId} --role owner --sdk-auth
   ```

1. Take the output of the above command and paste it into a [GitHub secret](https://docs.github.com/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository) named `AZURE_CREDENTIALS`. This secret will be used to access your AKS cluster, if applicable.

## Step 2: Create an environment

Next, you will create the environment that you will be deploying your applications into.

1. Download your kubectl context:

   {{< tabs AKS >}}

   {{% codetab %}}
   Replace subscriptionName, resourceGroupName, and clusterName with your values:
   ```bash
   az aks get-credentials --subscription subscriptionName --resource-group resourceGroupName --name aksName
   ```
   {{% /codetab %}}

   {{< /tabs >}}

1. Install the Radius runtime and create a new environment:

    ```bash
    rad env init kubernetes -i
    ```

    Specify the Kubernetes namespace you wish to use for application deployments.

    If you wish to deploy Azure resources, select the option to configure the Azure cloud provider, providing the values obtained in Step 1.

    Note the name of the environment you used when creating the environment. For this example we will use `myenv`.

## Step 3: Create a workflow file

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

This workflow begins by checking out the repository. It then sets up the kubectl tool to access your cluster.

### Download kubectl context

To interact with the cluster, the rad CLI requires a valid kubectl context.

{{< tabs AKS >}}

{{% codetab %}}
Ensure the service principal created above has the proper RBAC assignment to download the AKS context. Then append the following steps to your workflow:

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

Next, download the latest `rad` CLI release and connect to the environment you previously created (in this example `myenv`):

```yml
    - name: Download rad CLI and rad-bicep
      run: |
        wget -q "https://get.radapp.dev/tools/rad/install.sh" -O - | /bin/bash
        ./rad bicep download
        ./rad --version
    - name: Initialize Radius environment
      run: ./rad env init kubernetes -e myenv
```

### Deploy application

Finally, run the [`rad deploy`]({{< ref rad_deploy >}}) command to deploy your application. Specify the path to your application Bicep. If the application had been previously deployed, it will be updated.

```yml
    - name: Deploy app
      run: ./rad deploy ./iac/app.bicep
```

## Step 4: Commit and run your workflow

Commit and push your workflow to your repository. This will trigger your workflow to run, and your application to deploy:

```bash
git commit .github/workflows/deploy-radius.yml -m "Add Radius deploy workflow"
git push
```

Done!
