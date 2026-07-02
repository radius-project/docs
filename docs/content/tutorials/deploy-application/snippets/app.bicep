//IMPORT
extension radius
extension radiusResources
//IMPORT

//PARAM
@description('The ID of your Radius Environment. Set automatically by the rad CLI.')
param environment string
//PARAM

//APPLICATION
resource todolist 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'todolist'
  properties: {
    environment: environment
  }
}
//APPLICATION

//DATABASE
resource postgresql 'Radius.Data/postgreSqlDatabases@2025-08-01-preview' = {
  name: 'postgresql'
  properties: {
    environment: environment
    application: todolist.id
    size: 'S'
  }
}
//DATABASE

//CONTAINER
resource frontend 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'frontend'
  properties: {
    environment: environment
    application: todolist.id
    containers: {
      frontend: {
        image: 'ghcr.io/radius-project/samples/demo:latest'
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
    }
    connections: {
      postgresql: {
        source: postgresql.id
      }
    }
  }
}
//CONTAINER

