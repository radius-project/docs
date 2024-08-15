// Import the set of Radius resources (Applications.*) into Bicep
extension radius

@description('The ID of your Radius Application. Set automatically by the rad CLI.')
param application string

//CONTAINER
resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/tutorial/demo:edge'
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
    }
  }
}
//CONTAINER

//MONGO
@description('The ID of your Radius Environment. Set automatically by the rad CLI.')
param environment string

resource mongodb 'Applications.Datastores/mongoDatabases@2023-10-01-preview' = {
  name: 'mongodb'
  properties: {
    environment: environment
    application: application
  }
}
//MONGO
