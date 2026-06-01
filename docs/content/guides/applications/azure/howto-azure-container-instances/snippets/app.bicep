extension radius

param environment string = 'aci-demo'

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'demo-app'
  properties: {
    environment: environment
  }
}

resource redis 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'database'
  properties: {
    environment: environment
    application: app.id
  }
}

resource gateway 'Applications.Core/gateways@2023-10-01-preview' = {
  name: 'gateway'
  properties: {
    application: app.id
    routes: [
      {
        path: '/'
        destination: 'http://frontend:3000'
      }
    ]
  }
}

resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    connections: {
      redis: {
        source: redis.id
      }
    }
    extensions: [
      {
        kind:  'manualScaling'
        replicas: 2
      }
    ]
    runtimes: {
      aci: {
        gatewayID: gateway.id
      }
    }
  }
}
