---
type: docs
title: "How-To: Share portable resources between applications"
linkTitle: "Share between apps"
description: "Learn how to share portable resources between applications"
weight: 400
categories: "Overview"
---

This guide will show you how you can share portable resources between Radius applications.

## Pre-requisites

- [rad CLI]({{< ref "/guides/tooling/rad-cli/overview" >}})
- [rad development environment]({{< red "getting-started" >}})

## Step 1: Define an environment-scoped resource

Portable resources can be environment-scoped, where they follow the lifecycle of an environment instead of an application. Define a resource, such as a Redis cache, in your app.bicep file:

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 2: Deploy resource

Deploy the resource with [`rad deploy`]({{< ref rad_deploy >}}), using the 'local-dev' Recipe:

```bash
rad deploy app.bicep
```

You should see the resource deployed into your environment:

```

```

## Step 3: Verify the resource was deployed

Run [`rad resource show`]({{< ref rad_resource_show >}}) to verify the resource was deployed into the environment's Kubernetes namespace:

```bash
rad resource show rediscaches shared-cache -o json
```

You should see the raw JSON output, including the `outputResources` property which shows the Kubernetes namespace the Redis cache was deployed into. It will match the environment's namespace and not an application's:

```

```

## Done

Now that you have an environment-scoped resource you can define connections to it from any Radius container from any application. You can also cleanup with the resource with [`rad resource delete`]({{< ref rad_resource_delete >}}):

```bash
rad resource delete rediscaches shared-cache -y
```
