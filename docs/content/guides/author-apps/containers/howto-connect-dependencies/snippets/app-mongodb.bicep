import radius as rad

@description('The app ID of your Radius application. Set automatically by the rad CLI.')
param application string

//CONTAINER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'mycontainer'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/quickstarts/envvars:edge'
    }
    connections: {
      myconnection: {
        source: mongoDatabase.id
      }
    }
  }
}
//CONTAINER

//DB
@description('The environment ID of your Radius application. Set automatically by the rad CLI.')
param environment string

resource mongoDatabase 'Applications.Datastores/mongoDatabases@2023-10-01-preview' = {
  name: 'mongo-db'
  properties: {
    environment: environment
    application: application
    // Use the "default" Recipe to provision the MongoDB
  }
}
//DB
