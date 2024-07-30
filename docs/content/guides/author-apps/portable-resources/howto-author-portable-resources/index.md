---
type: docs
title: "How-To: Author portable resources"
linkTitle: "Author portable resources"
description: "Learn how to author portable resources in Radius"
weight: 200
categories: "How-To"
tags: ["portability"]
---

This guide will teach you how to author a portable resource for your [Radius Application]({{< ref "/guides/author-apps/application/overview" >}}).

## Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})
- [Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})

## Step 1: Add a portable resource

Portable resources provide **abstraction** and **portability** to Radius Applications. Radius currently offers options to manually provision the resources or automatically provision them via Recipes:

{{< tabs Recipe Manual >}}

{{% codetab %}}

Recipes handle infrastructure provisioning for you. You can use a Recipe to provision a Redis cache, using your environment's default Recipe.

Create a file named `app.bicep` and paste the following:

{{< rad file="snippets/app-redis-recipe.bicep" embed=true marker="//RECIPE" >}}

To learn more about Recipes visit the [Recipes overview page]({{< ref "/guides/recipes/overview" >}}).

{{% /codetab %}}

{{% codetab %}}

You can also manually manage your infrastructure and use a portable resource to abstract the details. Create a file named `app.bicep` and paste the following:

{{< rad file="snippets/app-redis-manual.bicep" embed=true marker="//MANUAL" >}}

{{% /codetab %}}

{{< /tabs >}}

## Step 2: Add a container

In your Bicep file `app.bicep`, add a container resource that will connect to the Redis cache. Note the connection to the Redis cache automatically injects connection-related environment variables into the container. Optionally, you can also manually access properties and set environment variables based on your portable resource values.

{{< rad file="snippets/app-redis-manual.bicep" embed=true marker="//CONTAINER" >}}

## Step 3: Deploy the app

1. Run your application in your environment:

    ```bash
    rad run ./app.bicep -a demo
    ```

1. Visit [localhost:3000](http://localhost:3000) in your browser. You should see the following page, now showing injected environment variables:

   {{< image src="demo-with-redis-screenshot.png" alt="Screenshot of the demo app with all environment variables" width=1000px >}}

## Cleanup

Run `rad app delete` to cleanup your Radius application, container, and Redis cache:

```bash
rad app delete -a demo
```

## Further reading

- [Portable resource overview]({{< ref "/guides/author-apps/portable-resources/overview" >}})
- [Radius Application overview]({{< ref "/guides/author-apps/application/overview" >}})
