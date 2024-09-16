extension radius

@description('The ID of your Radius Application. Automatically injected by the rad CLI.')
param application string

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
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

resource redis 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'demo-redis-manual'
  properties: {
    environment: environment
    application: application
  }
}

resource stateStore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
  name: 'demo-statestore'
  properties: {
    application: application
    environment: environment
    resourceProvisioning: 'manual'
    type: 'state.redis'
    version: 'v1'
    metadata: {
      redisHost: {
        value: '${redis.properties.host}:${redis.properties.port}'
      }
      // This value will be considered a secret later on
      redisUsername: {
        value: 'default'
      }
    }
  }
}

