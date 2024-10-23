---
type: docs
title: "How-To: Deploy an application with Github Actions"
linkTitle: "Deploy via GitHub Actions"
description: "Learn about adding your Radius apps to your deployment pipelines with GitHub Actions"
weight: 300
categories: "How-To"
tags: ["CI/CD"]
---

It's easy to get Radius added to your GitHub Actions deployment pipelines. By leveraging the `rad` CLI, you can keep your checked-in app definitions in sync with deployed instances of your app.

## Prerequisites

- [Setup a supported Kubernetes cluster]({{< ref "/guides/operations/kubernetes/overview#supported-clusters" >}})
- Radius control plane [installed in your cluster]({{< ref kubernetes-install >}})
- GitHub repo with Actions enabled

## Step 1: Create your environment and application definitions

Make sure you have the following files checked into your repository under `iac/`:

### `env.bicep`

{{< rad file="snippets/env.bicep" embed="true" >}}

### `app.bicep`

{{< rad file="snippets/app.bicep" embed="true" >}}

### [`bicepconfig.json`]({{< ref "/guides/tooling/bicepconfig/overview" >}})

```json
{
	"experimentalFeaturesEnabled": {
		"extensibility": true
	},
	"extensions": {
		"radius": "br:biceptypes.azurecr.io/radius:<release-version>",
		"aws": "br:biceptypes.azurecr.io/aws:<release-version>"
	}
}
```

## Step 2: Create your workflow file

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
      uses: actions/checkout@v4
    - name: Setup kubectl
      uses: azure/setup-kubectl@v1
```

This workflow begins by checking out the repository. It then sets up the kubectl tool to access your cluster.

## Step 3: Connect to your cluster

To interact with the cluster, the rad CLI requires a valid kubectl context. Add the following steps to your workflow to connect to your cluster:

{{< tabs AKS AWS >}}

{{% codetab %}}
Ensure the service principal created above has the proper RBAC assignment to download the AKS context. Then append the following steps to your workflow:

```yml
    - name: az Login
      uses: azure/login@v2
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
    - name: Configure kubectl context
      run: az aks get-credentials --name ${CLUSTER} --resource-group ${RESOURCE_GROUP} --subscription ${SUBSCRIPTION_ID}
```

{{% /codetab %}}

{{% codetab %}}

```yml
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-2
    - name: Get EKS kubeconfig
      run: aws eks update-kubeconfig --region us-east-2 --name my-cluster
```

{{% /codetab %}}

{{< /tabs >}}

## Step 4: Install the rad CLI and deploy environment

Next, download the latest `rad` CLI release and setup your workspace:

```yml
    - name: Download rad CLI and rad-bicep
      run: |
        wget -q "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" -O - | /bin/bash
        ./rad bicep download
        ./rad --version
    - name: Initialize Radius Environment
      run: |
        ./rad group create default
        ./rad workspace create kubernetes default --group default
        ./rad env create temp
        ./rad env switch temp
```

> **Note**: Radius currently requires an environment be present in order to deploy an environment via Bicep. This will be fixed in an upcoming release.

## Step 5: Deploy application

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
