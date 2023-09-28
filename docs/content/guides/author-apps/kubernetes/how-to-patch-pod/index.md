---
type: docs
title: "How-To: Patch Kubernetes resources using PodSpec"
linkTitle: "Patch with PodSpec"
description: "Learn how to patch Kubernetes resources using PodSpec definitions"
weight: 400
slug: 'patch-podspec'
categories: "How-To"
tags: ["containers","Kubernetes"]
---

This how-to guide will provide an overview of how to:

- Mount an ephemeral (short-lived) volume to a container

## Prerequisites

- [rad CLI]({{< ref getting-started >}})
- [Radius environment]({{< ref "/guides/deploy-apps/environments/overview" >}})

## Step 1: Define an app and a container

Begin by creating a file named `app.bicep` with a Radius application and [container]({{< ref "guides/author-apps/containers" >}}):

{{< rad file="snippets/1-app.bicep" embed=true >}}

The `quickstarts/volumes` container will display the status and contents of the `/tmpdir` directory within the container.

## Step 2: Deploy the app and container

1. Deploy your app with the command:

   ```bash
   rad deploy ./app.bicep
   ```
1. Once complete, port forward to your container with [`rad resource expose`]({{< ref rad_resource_expose >}}):

   ```bash
   rad resource expose containers mycontainer -a myapp --port 5000
   ```
1. You should see a message warning that the directory `/tmpdir` does not exist:

   <img src="screenshot-error.jpg" width=500px alt="Screeshot of container showing that the tmp directory does not exist">

## Step 3: Add an ephemeral volume

Within the `container.volume` property, add a new volume named `temp` and configure it as a memory-backed ephemeral volume:

{{< rad file="snippets/2-app.bicep" embed=true marker="//CONTAINER" >}}

## Redeploy your app and container

1. Redeploy your application to apply the new definition of your container:

   ```bash
   rad deploy ./app.bicep
   ```

1. Once complete, port forward to your container with [`rad resource expose`]({{< ref rad_resource_expose >}}):

   ```bash
   rad resource expose containers mycontainer -a myapp --port 5000
   ```
   
1. Visit [localhost:5000](http://localhost:5000) in your browser. You should see the contents of `/tmpdir`, showing an empty directory.

   <img src="screenshot-empty.jpg" width=500px alt="Screeshot of container showing that the tmp directory has no items">
1. Press the `Create file` button to generate a new file in the directory, such as `test.txt`:

   <img src="screenshot.jpg" width=400px alt="Screeshot of container showing files being created">
1. Done! You've now learned how to mount an ephemeral volume

## Cleanup

1. Run the following command to delete your app and container:

   ```bash
   rad app delete myapp
   ```