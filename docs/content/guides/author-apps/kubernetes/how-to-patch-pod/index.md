---
type: docs
title: "How-To: Patch Kubernetes resources using PodSpec"
linkTitle: "Patch with PodSpec"
description: "Learn how to patch Kubernetes resources using PodSpec definitions"
weight: 300
slug: 'patch-podspec'
categories: "How-To"
tags: ["containers","Kubernetes"]
---

This how-to guide will provide an overview of how to:

- Patch Radius-created Kubernetes resources using [PodSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec) definitions

## Prerequisites

- [rad CLI]({{< ref getting-started >}})
- [Radius initialized with `rad init`]({{< ref howto-environment >}})
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Step 1: Define an app and a container

Begin by creating a file named `app.bicep` with a Radius application and [container]({{< ref "guides/author-apps/containers" >}}):

{{< rad file="snippets/patch-container.bicep" embed=true >}}

## Step 2: Deploy the app and container

1. Deploy and run your app with the command:

   ```bash
   rad run ./app.bicep
   ```

   Once the deployment completes successfully, you should see the following confirmation message along with some system logs:

   ```
   Deployment Complete

   Resources:
      demo            Applications.Core/containers
   ```

2. In a separate terminal window, run the following command, making sure to specify the Kubernetes namespace to which you deployed your app:

   ```bash
   kubectl get pods -n <YOUR_KUBERNETES_NAMESPACE> -l app.kubernetes.io/name=demo -o custom-columns=POD:.metadata.name,STATUS:.status.phase,CONTAINER_NAMES:spec.containers[:].name,CONTAINER_IMAGES:spec.containers[:].image
   ```

   You should see output confirming that a single container named `demo` was deployed and is running in your pod, similar to the following:

   ```
   POD                    STATUS    CONTAINER_NAMES   CONTAINER_IMAGES
   demo-df76d886c-9p4gv   Running   demo              radius.azurecr.io/tutorial/webapp:edge
   ```

## Step 3: Add a PodSpec to the container definition

//TODO

## Step 4: Redeploy the app with the PodSpec

//TODO