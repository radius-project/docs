import radius as rad

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//CONTAINER
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
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
resource mongoDatabase 'Applications.Datastores/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'mongo-db'
  properties: {
    environment: environment
    application: app.id
    // Use the "default" Recipe to provision the MongoDB
  }
}
//LINK
