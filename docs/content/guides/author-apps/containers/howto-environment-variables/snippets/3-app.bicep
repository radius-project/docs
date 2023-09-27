import radius as rad

param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//CONTAINER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'mycontainer'
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/quickstarts/envvars:edge'
      env: {
        FOO: 'BAR'
        BAZ: app.name
      }
    }
    connections: {
      myconnection: {
        source: mongoDatabase.id
      }
    }
  }
}
//CONTAINER

//LINK
resource mongoDatabase 'Applications.Datastores/mongoDatabases@2023-10-01-preview' = {
  name: 'mongo-db'
  properties: {
    environment: environment
    application: app.id
    // Use the "default" Recipe to provision the MongoDB
  }
}
//LINK
