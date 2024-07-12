---
type: docs
title: "How-To: Mount a volume to a container"
linkTitle: "Mount a volume"
description: "Learn how to mount a volume to a container" 
weight: 500
slug: 'volumes'
categories: "How-To"
tags: ["containers"]
---

This how-to guide will provide an overview of how to:

- Mount an ephemeral (short-lived) volume to a container

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension and Bicep configuration file]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})

## Step 1: Define an app and a container

Begin by creating a file named `app.bicep` with a Radius Application and [container]({{< ref "guides/author-apps/containers" >}}):

{{< rad file="snippets/1-app.bicep" embed=true >}}

The `samples/volumes` container will display the status and contents of the `/tmpdir` directory within the container.

## Step 2: Deploy the app and container

1. Deploy your app with the command:

   ```bash
   rad deploy ./app.bicep
   ```

1. Once complete, port forward to your container with [`rad resource expose`]({{< ref rad_resource_expose >}}):

   ```bash
   rad resource expose containers mycontainer -a myapp --port 5000
   ```

1. Visit [localhost:5000](http://localhost:5000) in your browser. You should see a message warning that the directory `/tmpdir` does not exist:

   {{< image src="screenshot-error.jpg" width=500px alt="Screenshot of container showing that the tmp directory does not exist" >}}

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

   {{< image src="screenshot-empty.jpg" width=500px alt="Screenshot of container showing that the tmp directory has no items" >}}
1. Press the `Create file` button to generate a new file in the directory, such as `test.txt`:

   {{< image src="screenshot.jpg" width=400px alt="Screenshot of container showing files being created" >}}
1. Done! You've now learned how to mount an ephemeral volume

## Cleanup

1. Run the following command to delete your app and container:

   ```bash
   rad app delete myapp
   ```
