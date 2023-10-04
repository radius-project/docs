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

{{< rad file="snippets/kubernetes-container.bicep" embed=true >}}

## Step 2: Deploy the app and container

1. Deploy your app with the command:

   ```bash
   rad deploy ./app.bicep
   ```

2. Confirm that a your app with a single container has been deployed:

   //TODO

## Step 3: Add a PodSpec to the container definition

//TODO

## Step 4: Redeploy the app with the PodSpec

//TODO