//MANUAL
extension radius

@description('Specifies the environment for resources.')
param environment string

@description('Specifies the application for resources.')
param application string

resource redis 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'myredis'
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

//CONTAINER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      env: {
        // Manually access Redis connection information
        REDIS_CONNECTION: redis.listSecrets().connectionString
      }
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    connections: {
      // Automatically inject connection details
      redis: {
        source: redis.id
      }
    }
  }
}
//CONTAINER
