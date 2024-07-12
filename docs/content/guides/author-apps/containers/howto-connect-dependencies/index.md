---
type: docs
title: "How-To: Connect to dependencies"
linkTitle: "Connect to dependencies"
description: "Learn how to connect to dependencies in your application via connections"
weight: 200
categories: "How-To"
tags: ["containers"]
---

This how-to guide will teach how to connect to your dependencies via [connections]({{< ref "guides/author-apps/containers#connections" >}})

## Prerequisites

- [rad CLI]({{< ref "installation#step-1-install-the-rad-cli" >}})
- [Bicep VSCode extension and Bicep configuration file]({{< ref "installation#step-2-install-the-vs-code-extension" >}})
- [Radius environment]({{< ref "installation#step-3-initialize-radius" >}})

## Step 1: View the container definition

Open the `app.bicep` and view the [container]({{< ref "guides/author-apps/containers" >}}):

{{< rad file="snippets/app.bicep" embed=true >}}

## Step 2: Add a Redis cache as a dependency

Next, add to `app.bicep` a [Redis cache]({{< ref "/guides/author-apps/portable-resources/overview" >}}), leveraging the default "local-dev" Recipe:

{{< rad file="snippets/app-with-redis.bicep" embed=true marker="//DB" >}}

## Step 3: Connect to the Redis cache

Connections from a container to a resource result in environment variables for connection information automatically being set on the container. Update your container definition to add a connection to the new Redis cache:

{{< rad file="snippets/app-with-redis.bicep" embed=true marker="//CONTAINER" markdownConfig="{linenos=table,hl_lines=[\"13-17\"],linenostart=7}" >}}

## Step 4: Deploy your app

1. Run your application in your environment:

   ```bash
   rad run ./app.bicep -a demo
   ```

1. Visit [localhost:3000](http://localhost:3000) in your browser. You should see the following page, now showing injected environment variables:

   {{< image src="./demo-with-redis-screenshot.png" alt="Screenshot of the demo app with all environment variables" width=1000px >}}

## Step 5: View the Application Connections

Radius Connections are more than just environment variables and configuration. You can also access the "application graph" and understand the connections within your application with the following command:

```bash
rad app graph -a demo
```

You should see the following output, detailing the connections between the `demo` container and the `db` Redis cache, along with information about the underlying Kubernetes resources running the app:

```
Displaying application: demo

Name: demo (Applications.Core/containers)
Connections:
  demo -> db (Applications.Datastores/redisCaches)
Resources:
  demo (kubernetes: apps/Deployment)
  demo (kubernetes: core/Secret)
  demo (kubernetes: core/Service)
  demo (kubernetes: core/ServiceAccount)
  demo (kubernetes: rbac.authorization.k8s.io/Role)
  demo (kubernetes: rbac.authorization.k8s.io/RoleBinding)

Name: db (Applications.Datastores/redisCaches)
Connections:
  demo (Applications.Core/containers) -> db
Resources:
  redis-r5tcrra3d7uh6 (kubernetes: apps/Deployment)
  redis-r5tcrra3d7uh6 (kubernetes: core/Service)
```

## Cleanup

Run `rad app delete` to cleanup your Radius application, container, and Redis cache:

```bash
rad app delete -a demo
```

## Further reading

- [Connections]({{< ref "guides/author-apps/containers/overview#connections" >}})
- [Container schema]({{< ref container-schema >}})
