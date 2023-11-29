import radius as radius

@description('Specifies the environment for resources.')
param environment string

@description('Specifies the application for resources.')
param application string

//CONTAINER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
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
      livenessProbe: {
        kind: 'httpGet'
        containerPort: 3000
        path: '/healthz'
        initialDelaySeconds: 10
      }
    }
    connections: {
      redis: {
        source: portableRedis.id
      }
    }
  }
}
//CONTAINER

//MANUAL
resource portableRedis 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'redisCache'
  properties: {
    environment: environment
    application: application
    resourceProvisioning: 'manual'
    username: 'myusername'
    host: 'mycache.contoso.com'
    port: 8080
    secrets: {
      password: '******'
    }
  }
}
//MANUAL

