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

This guide adds a Redis cache to an application and connects a Container to it. It builds on the definition from [How to model an application definition]({{< ref "/applications/definitions" >}}).

## Step 1: Start from an application definition

Begin with a definition that declares an Application and a Container. The following `app.bicep` defines a `frontend` Container:

```bicep
extension radius

@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string

resource app 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'my-app'
  properties: {
    environment: environment
  }
}

resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    environment: environment
    application: app.id
    containers: {
      web: {
        image: 'ghcr.io/radius-project/samples/demo:latest'
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
    }
  }
}
```

See [How to model an application definition]({{< ref "/applications/definitions" >}}) to build this file from scratch.

## Step 2: Add the resource to connect to

Add the dependency the Container needs. The following example adds a `Radius.Data/redisCaches` resource named `db` to the same Application:

```bicep
resource db 'Radius.Data/redisCaches@2025-08-01-preview' = {
  name: 'db'
  properties: {
    environment: environment
    application: app.id
  }
}
```

## Step 3: Connect the Container to the resource

Add a `connections` entry to the Container's `properties`. Each connection has a name and a `source` set to the target resource's `.id`:

```bicep
resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    environment: environment
    application: app.id
    containers: {
      web: {
        image: 'ghcr.io/radius-project/samples/demo:latest'
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
    }
    connections: {
      redis: {
        source: db.id
      }
    }
  }
}
```

The connection name (`redis`) becomes the prefix of the environment variables Radius injects into the Container. Referencing `db.id` also orders the deployment so Radius creates the cache before the Container.

## Step 4: Deploy the application

Deploy the updated definition with [`rad deploy`]({{< ref rad_deploy >}}):

```bash
rad deploy app.bicep
```

Radius provisions the Redis cache, injects its connection details into the Container, and records the connection in the Application graph.

## Step 5: Inspect the connection in the Application graph

Use [`rad application graph`]({{< ref rad_application_graph >}}) to view the resources and the connection between them:

<!-- TODO: Remove the `--preview` flag when the Radius.Core Application implementation is no longer in preview. -->
```bash
rad application graph --application my-app --preview
```

The output shows the `frontend` Container connected to the `db` cache, along with the infrastructure each resource created:

```text
Displaying application: my-app

Name: frontend (Radius.Compute/containers)
Connections:
  frontend -> db (Radius.Data/redisCaches)
Resources:
  frontend (kubernetes: apps/Deployment)
  frontend (kubernetes: core/Service)

Name: db (Radius.Data/redisCaches)
Connections:
  frontend (Radius.Compute/containers) -> db
Resources:
  db (kubernetes: apps/Deployment)
  db (kubernetes: core/Service)
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
