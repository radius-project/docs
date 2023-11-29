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
- [Radius Bicep VSCode extension]({{< ref "installation#step-2-install-the-vs-code-extension" >}})

## Step 1: Choose how to define your portable resource

Portable resources provide **abstraction** and **portability** to Radius Applications. Radius currently offers options to manually provision the resources or automatically provision them via Recipes.

{{< tabs Recipe Manual >}}

{{% codetab %}}

Recipes enable a separation of concerns between infrastructure operators and developers by automating infrastructure deployment. You can run a default recipe registered in your environment or select the specific Recipe you want to run. 

{{< rad file="snippets/app-redis-recipe.bicep" embed=true marker="//Recipe" >}}

 To learn more visit the [Recipes overview]({{< ref "/guides/recipes/overview" >}}).

{{% /codetab %}}

{{% codetab %}}

Add a RedisCache resource with the `resourceProvisioning` mode as `manual`. This enables you to configure the underlying Redis resource

{{< rad file="snippets/app-redis-manual.bicep" embed=true marker="//MANUAL" >}}

Refer to the [Redis resource schema]({{< ref "reference/resource-schema/cache/redis" >}}) for more details.

{{% /codetab %}}

{{< /tabs >}}

## Step 2: Define a container resource

In your Bicep file `app.bicep`, add a container resource that will be leveraged by your portable resource later:

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 3: Access your portable resources

You can access the portable resource via [`connections`]({{< ref "guides/author-apps/containers#connections" >}}). Update your container definition to add a connection to the new Redis cache. This results in environment variables for connection information automatically set on the container.

{{< rad file="snippets/app-redis-manual.bicep" embed=true >}}

## Step 4: Deploy your app

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
