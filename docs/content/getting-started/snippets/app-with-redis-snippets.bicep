// Import the set of Radius resources (Applications.*) into Bicep
extension radius

@description('The app ID of your Radius Application. Set automatically by the rad CLI.')
param application string

//CONNECTION
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
    connections: {
      redis: {
        source: db.id
      }
    }
  }
}
//CONNECTION

//REDIS
@description('The environment ID of your Radius Application. Set automatically by the rad CLI.')
param environment string

resource db 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'db'
  properties: {
    application: application
    environment: environment
  }
}
//REDIS
