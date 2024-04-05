---
type: docs
title: "How-To: Access Kubernetes secrets using PodSpec"
linkTitle: "Secrets using PodSpec"
description: "Learn how to patch Kubernetes secrets into the container environment using PodSpec definitions"
weight: 300
slug: 'secrets-podspec'
categories: "How-To"
tags: ["containers","Kubernetes", "secrets"]
---

This how-to guide will provide an overview of how to:

- Patch existing Kubernetes secrets using [PodSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec) definitions and provide them to the environment of a container.

## Prerequisites

- [rad CLI]({{< ref getting-started >}})
- [Radius initialized with `rad init`]({{< ref howto-environment >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Step 1: Define a container

Begin by creating a file named `app.bicep` with a Radius [container]({{< ref "guides/author-apps/containers" >}}):

{{< rad file="snippets/secrets-container.bicep" embed=true >}}

## Step 2: Deploy the app and container

Run this command to deploy the app and container:

```bash
rad run ./app.bicep -a demo
```

Once the deployment completes successfully, you should see the following confirmation message along with some system logs:

```bash
Building app.bicep...
Deploying template 'app.bicep' for application 'demo' and environment 'dev' from workspace 'dev'...

Deployment In Progress...

..                   demo            Applications.Core/containers
Completed            demo            Applications.Core/applications

Deployment Complete

Resources:
    demo            Applications.Core/applications
    demo            Applications.Core/containers

Starting log stream...

+ demo-7d94db59f6-ps6cf › demo
demo-7d94db59f6-ps6cf demo No APPLICATIONINSIGHTS_CONNECTION_STRING found, skipping Azure Monitor setup
demo-7d94db59f6-ps6cf demo Using in-memory store: no connection string found
demo-7d94db59f6-ps6cf demo Server is running at http://localhost:3000
dashboard-7f7db87c5-7d2jf dashboard [port-forward] connected from localhost:7007 -> ::7007
demo-7d94db59f6-ps6cf demo [port-forward] connected from localhost:3000 -> ::3000
```

Verify the pod is running:
    
```bash
kubectl get pods -n dev-demo
```

## Step 3: Create a secret

Create a secret in your Kubernetes cluster using the following command:

```bash
kubectl create secret generic my-secret --from-literal=secret-key=secret-value -n dev-demo
```

Verify the secret is created:

```bash
kubectl get secrets -n dev-demo
```

## Step 4: Patch the secret

Patch the secret into the container by adding the following `runtimes` block to the `container` resource in your `app.bicep` file:

{{< rad file="snippets/secrets-patch.bicep" embed=true markdownConfig="{linenos=table,hl_lines=[\"25-60\"]}" >}}

## Step 5: Redeploy the app and container

Redeploy and run your app:

```bash
rad app deploy demo
```

Once the deployment completes successfully, you should see the environment variable in the container.

To validate this, first get the pod name:

```bash
kubectl get pods -n dev-demo

Then, exec into the pod and check the environment variable (substitute the pod name with the one you got from the previous command):

{{< tabs "macOS/Linux/WSL" "Windows" >}}

{{% codetab %}}

```bash
kubectl -n dev-demo exec demo-d64cc4d6d-xjnjz -- env | grep MY_SECRET
```

{{% /codetab %}}

{{% codetab %}}

```powershell
kubectl -n dev-demo exec demo-d64cc4d6d-xjnjz -- env | findstr MY_SECRET
```

{{% /codetab %}}

{{< /tabs >}}

## Cleanup

Run the following command to [delete]({{< ref "guides/deploy-apps/howto-delete" >}}) your app and container:

```bash
rad app delete demo
```

## Further reading

- [Kubernetes in Radius containers]({{< ref "guides/author-apps/containers/overview#kubernetes" >}})
- [PodSpec in Radius containers]({{< ref "reference/resource-schema/core-schema/container-schema#runtimes" >}})