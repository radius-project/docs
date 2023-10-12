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

### Prerequisites

Before you get started, you'll need to make sure you have the following tools and resources:
- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-the-radius-control-plane-and-the-radius-environment" >}})
- [Radius Bicep VSCode extension]({{< ref "installation#step-2-install-the-radius-bicep-extension" >}})

## Step 1: Define a container resource

Create a Bicep file `app.bicep`, add a container resource that will be leveraged by your portable resource later:

{{< rad file="snippets/app.bicep" embed=true marker="//EMPTYCONTAINER" >}}

## Step 2: Define your portable resource

{{< tabs Recipe Manual >}}

{{% codetab %}}

Recipes enable a separation of concerns between infrastructure operators and developers by automating infrastructure deployment. To learn more visit the [Recipes overview]({{< ref "/guides/recipes/overview" >}})

{{% /codetab %}}

{{% codetab %}}

Find the schema needed for the supported Radius resource by visiting the [Radius resource schema docs]({{< ref resource-schema >}}). For this example you can follow along and define a RedisCache resource:

{{< rad file="snippets/app-redis-manual.bicep" embed=true marker="//MANUAL" >}}

{{% /codetab %}}

{{< /tabs >}}

## Step 3: Accessing your portable resource

Users can leverage their portable resources and establish connections to their container resources by adding accessing properties:

{{< rad file="snippets/app-redis-manual.bicep" embed=true marker="//CONTAINER" markdownConfig="{linenos=table,hl_lines=[\"19-22\"]}">}}

## Step 4: Deploy your app

1. Run your application in your environment:

    ```bash
    rad run ./app.bicep -a demo
    ```

1. Visit [localhost:3000](http://localhost:3000) in your browser. You should see the following page, now showing injected environment variables:

   <img src="./demo-with-redis-screenshot.png" alt="Screenshot of the demo app with all environment variables" width=1000px />

## Cleanup

Run `rad app delete` to cleanup your Radius application, container, and Redis cache:

```bash
rad app delete -a demo
```

## Further reading

- [Portable resource overview]({{< ref portable-resources >}})
- [Radius Application overview]({{< ref "/guides/author-apps/application/overview" >}})
