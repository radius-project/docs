---
type: docs
title: "How to use Dapr and Radius together"
linkTitle: "Use Dapr with Radius"
description: "Learn how to configure Dapr sidecars and building blocks with Radius"
weight: 200
aliases:
  - /guides/dapr/
  - /guides/dapr/overview/
  - /guides/dapr/how-to-dapr-sidecar/
  - /guides/dapr/how-to-dapr-building-block/
  - /guides/dapr/how-to-dapr-secrets/
  - /guides/applications/dapr/
  - /guides/applications/dapr/overview/
  - /guides/applications/dapr/how-to-dapr-sidecar/
  - /guides/applications/dapr/how-to-dapr-building-block/
  - /guides/applications/dapr/how-to-dapr-secrets/
---

Radius integrates with [Dapr](https://dapr.io/) by configuring Dapr sidecars on Containers and modeling Dapr building blocks as Radius resources. Radius deploys the Dapr components with the Application and adds them to the Application graph.

This guide focuses on three independent integration patterns: configuring sidecars and building blocks, enabling service invocation, and referencing secrets from Dapr components. See the [Dapr documentation](https://docs.dapr.io/) for installing Dapr and using its APIs, SDKs, and building blocks.

{{% alert title="Legacy Resource Types" color="warning" %}}
The Dapr integration uses the `Applications.Core`, `Applications.Dapr`, and `Applications.Datastores` Resource Types. These legacy Resource Types remain supported for this integration. Use current `Radius.*` Resource Types for applications that do not require these Dapr resources.
{{% /alert %}}

## Configure a sidecar and building block

The following example defines:

- A Container with a Dapr sidecar.
- A Dapr state store named `statestore`.
- A connection from the Container to the state store.

```bicep
extension radius

@description('The Radius Application ID. Injected automatically by the rad CLI.')
param application string

@description('The Radius Environment ID. Injected automatically by the rad CLI.')
param environment string

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'demo'
        appPort: 3000
      }
    ]
    connections: {
      redis: {
        source: stateStore.id
      }
    }
  }
}

resource stateStore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
  name: 'statestore'
  properties: {
    environment: environment
    application: application
  }
}
```

The `daprSidecar` extension configures Dapr for the Container:

- `appId` is the Dapr application ID used for service invocation.
- `appPort` is the port where the application listens for requests from the sidecar.

The `Applications.Dapr/stateStores` resource represents a Dapr state store component. The Recipe configured for this Resource Type provisions its backing infrastructure and creates the Dapr component. Radius includes the Container, sidecar configuration, state store, and Recipe-provisioned infrastructure in the same Application.

### Use the component name

The Dapr component name is the name of the Radius Dapr resource. In the example, the component name is `statestore`.

The connection named `redis` makes the component name available to the Container in the `CONNECTION_REDIS_COMPONENTNAME` environment variable. Use a connection instead of duplicating the component name in the Container configuration.

Application code can pass that component name to the appropriate [Dapr building block API or SDK](https://docs.dapr.io/developing-applications/building-blocks/).

## Configure service invocation

Set a unique `appId` on each Container's Dapr sidecar. A calling service uses the target Container's `appId` when invoking it through Dapr.

In the sidecar example above, other services invoke the `demo` App ID through the [Dapr service invocation API or SDK](https://docs.dapr.io/developing-applications/building-blocks/service-invocation/). The calling Container also needs a Dapr sidecar, but it does not need a Radius connection to the target Container.

## Reference secrets from a Dapr component

For manually configured Dapr components, use `secretKeyRef` for sensitive metadata and select the Dapr secret store through `auth.secretStore`:

```bicep
resource stateStore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
  name: 'statestore'
  properties: {
    environment: environment
    application: application
    resourceProvisioning: 'manual'
    type: 'state.redis'
    version: 'v1'
    auth: {
      secretStore: secretStore.name
    }
    metadata: {
      redisHost: {
        value: 'redis.example.com:6379'
      }
      redisUsername: {
        secretKeyRef: {
          name: 'redis-auth'
          key: 'username'
        }
      }
    }
  }
}

resource secretStore 'Applications.Dapr/secretStores@2023-10-01-preview' = {
  name: 'secretstore'
  properties: {
    environment: environment
    application: application
  }
}
```

The referenced secret must exist in the selected Dapr secret store. See the [Dapr secret store documentation](https://docs.dapr.io/operations/components/setup-secret-store/) for provider-specific configuration.
