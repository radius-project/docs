---
type: docs
title: "Known issues with the latest Radius release"
linkTitle: "Known issues"
description: "Learn where there are known issues with the latest Radius release and how to workaround them."
weight: 998
---

## Radius environments require Owner rights on the subscription
Creating Radius environments on Azure currently **require you to have *Owner* rights on your subscription.** (This is a current limitation that will be resolved once we've built our Azure Service.)  
   If you use a service principal for CLI authentication, ensure it also has the proper RBAC assignment on your subscription.

## Starters require an `existing` resource and `dependsOn`

[Starters]({{< ref starter-templates >}}) allow users to quickly get up and running with [Radius connectors]({{< ref connectors >}}).

In a future Radius release, the intended use of starters is through Bicep module outputs:

```sh
resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  resource frontend 'Container' = {
    name: 'frontend'
    properties: {
      container: {...}
      connections: {
        redis: {
          kind: 'redislabs.com/RedisCache'
          source: redisStarter.outputs.redis.id
        } 
      }
    }
  }
}

resource redisStarter 'br:radius.azurecr.io/starters/redis:latest' = {
  name: 'redis-starter'
  properties: {
    radiusApplication: app
    cacheName: 'mycache'
  }
}
```

Module outputs currently [cannot be referenced outside of a module](https://github.com/Azure/bicep/issues/6065).

### Workaround

Until this is resolved, the connector that was created by the starter needs to be referenced via an `existing` resource. Additionally, a `dependsOn` needs to be added to the consuming resource to ensure the connector is created before the consuming resource is created:

```sh
resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  resource frontend 'Container' = {
    name: 'frontend'
    properties: {
      container: {...}
      connections: {
        redis: {
          kind: 'redislabs.com/RedisCache'
          source: redis.id
        } 
      }
    }
    dependsOn: [
      redisStarter
    ]
  }

  resource redis 'redislabs.com.RedisCache' existing = {
    name: 'mycache'
  }
}

resource redisStarter 'br:radius.azurecr.io/starters/redis:latest' = {
  name: 'redis-starter'
  properties: {
    radiusApplication: app
    cacheName: 'mycache'
  }
}
```

## Deployments to Azure with starters fail on the first attempt

Due to the issue outlined above, the `existing` redis connector resource is required to reference a connector created by a starter. Since `existing` resources cannot list depenndencies via `dependsOn`, the `existing` resource may be deployed before the starter and its contents are deployed. When deploying to Azure, this results in a deployment failure.

### Workaround

Once the first deployment has completed with a failure, redeploy. The connector created by the starter will have alrady been created, and the second deployment will succeed.

This is not an issue for Kuberentes or local environments.

## Application names with capitol letters fail

Applications can currently only have lower-case letters in their names. This is being resolved with the move from custom resource provider to a full resource provider.

### Workaround

Make sure your application names only contain lower-case letters.
