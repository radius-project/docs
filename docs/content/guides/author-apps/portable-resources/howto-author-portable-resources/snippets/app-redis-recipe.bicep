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
      env: {
        connectionString: recipeRedis.connectionString()
      }
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
        source: recipeRedis.id
      }
    }
  }
}
//CONTAINER

//Recipe
resource recipeRedis 'Applications.Datastores/redisCaches@2023-10-01-preview'= {
  name: 'myresource'
  properties: {
    environment: environment
    application: application
  }
}
//Recipe

