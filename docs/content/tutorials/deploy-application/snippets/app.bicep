//IMPORT
extension radius

extension radiusResources
//IMPORT

//PARAM
@description('The ID of your Radius Application. Set automatically by the rad CLI.')
param application string

@description('The ID of your Radius Environment. Set automatically by the rad CLI.')
param environment string
//PARAM

//APPLICATION
resource todolist 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'todolist'
  properties: {
    environment: environment
  }
}
//APPLICATION

//CONTAINER
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
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
      database: {
        source: database.id
      }
    }
  }
}
//CONTAINER

//DATABASE
resource database 'Radius.Data/postgreSqlDatabases@2025-08-01-preview' = {
  name: 'database'
  properties: {
    environment: environment
    application: application
    size: 'S'
  }
}
//DATABASE
