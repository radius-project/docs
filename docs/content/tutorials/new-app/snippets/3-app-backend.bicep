// Import the set of Radius resources (Applications.*) into Bicep
import radius as radius

@description('The ID of your Radius Application. Set automatically by the rad CLI.')
param application string

@description('The environment ID of your Radius application. Set automatically by the rad CLI.')
param environment string

//CONTAINER
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/samples/demo:latest'
      env: {
        FOO: 'bar'
      }
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    connections: {
      mongodb: {
        source: mongodb.id
      }
      backend: {
        source: 'http://backend:3000'
      }
    }
  }
}
//CONTAINER

//MONGO
resource mongodb 'Applications.Datastores/mongoDatabases@2023-10-01-preview' = {
  name: 'mongodb'
  properties: {
    environment: environment
    application: application
  }
}
//MONGO

//BACKEND
resource backend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'backend'
  properties: {
    application: application
    container: {
      image: 'nginx:latest'
      ports: {
        api: {
          containerPort: 80
        }
      }
    }
  }
}
//BACKEND
