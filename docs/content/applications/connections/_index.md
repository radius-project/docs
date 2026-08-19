---
type: docs
title: "How to model application dependencies using connections"
linkTitle: "Model application dependencies"
description: "Learn how to use connections to model dependencies within your application"
weight: 200
aliases:
  - /guides/connections/
---

A connection is an explicit relationship between two resources in your [Application]({{< ref "/concepts/applications" >}}). Declaring a connection from a Container to another resource adds an edge to the Application graph and injects the connected resource's properties into the Container as environment variables. Your application then reads those variables instead of hard-coding hosts, ports, or credentials.

This guide adds a Redis cache to an application and connects a Container to it. It builds on the definition from [How to model application resources]({{< ref "/applications/definitions" >}}).

## Step 1: Start from an application definition

Begin with the Radius Demo `app.bicep` from [How to model application resources]({{< ref "/applications/definitions" >}}). It declares a `demoApp` Application and a `demoContainer` Container, which the following steps connect to a Redis cache.

## Step 2: Add the resource to connect to

<!-- markdownlint-disable-next-line MD033 -->
Add the dependency the Container needs. The demo's <a href="https://github.com/radius-project/samples/blob/{{< param version >}}/samples/demo/app-redis.bicep" target="_blank" rel="noopener">`app-redis.bicep`</a> definition adds a `Radius.Data/redisCaches` resource named `redis` to the same Application:

{{< rad file="/static/samples/demo/app-redis.bicep" embed=true startLine=40 endLine=47 >}}

## Step 3: Connect the Container to the resource

Add a `connections` entry to the Container's `properties`. Each connection has a name and a `source` set to the target resource's `.id`:

{{< rad file="/static/samples/demo/app-redis.bicep" embed=true startLine=17 endLine=38 markdownConfig=`{hl_lines=["16-20"]}` >}}

The connection name (`redis`) becomes the prefix of the environment variables Radius injects into the Container. Referencing `redis.id` also orders the deployment so Radius creates the cache before the Container.

## Step 4: Deploy the application

Deploy the updated definition from its published URL with [`rad deploy`]({{< ref rad_deploy >}}):

{{< rad-deploy path="samples/demo/app-redis.bicep" >}}

Radius provisions the Redis cache, injects its connection details into the Container, and records the connection in the Application graph.

## Step 5: Inspect the connection in the Application graph

Use [`rad application graph`]({{< ref rad_application_graph >}}) to view the resources and the connection between them. The sample includes the Environment name in its resource names; the following command uses the default Environment:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application graph --application demo-default --preview
```

The output shows the `demo-default` Container connected to the `redis-default` cache, along with the infrastructure each resource created:

```text
Displaying application: demo-default

Name: demo-default (Radius.Compute/containers)
Connections:
  demo-default -> redis-default (Radius.Data/redisCaches)
Resources:
  demo-default (kubernetes: apps/Deployment)
  demo-default (kubernetes: core/Service)

Name: redis-default (Radius.Data/redisCaches)
Connections:
  demo-default (Radius.Compute/containers) -> redis-default
Resources:
  redis-default (kubernetes: apps/Deployment)
  redis-default (kubernetes: core/Service)
```

## Connection environment variables

When a Container connects to another resource, Radius injects an environment variable for each property the connected resource exposes. The variables follow the pattern `CONNECTION_<CONNECTION-NAME>_<PROPERTY-NAME>`, uppercased. Radius manages the values securely through the Environment.

For the `redis` connection above, Radius injects a variable for each property the Redis cache exposes. For example, a cache that returns `host`, `port`, and `password` produces:

- `CONNECTION_REDIS_HOST`
- `CONNECTION_REDIS_PORT`
- `CONNECTION_REDIS_PASSWORD`

The exact variables depend on the properties defined by the connected Resource Type. See the [Resource Types reference]({{< ref "/reference/resources" >}}) for each type's properties, and [Connections]({{< ref "/concepts/applications#connections" >}}) in the Applications concept for how the graph and variables are built.

To use your own naming convention, ignore the generated variables and set explicit environment variables on the Container instead.

## Next steps

With the dependency connected, deploy and manage the complete Application.

{{< button text="Next step: How to deploy applications using Radius" page="/applications/deploy" >}}
