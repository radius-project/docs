import radius as radius

param environmentId string

//COSMOS
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' existing = {
  name: 'myaccount'
  
  resource db 'mongodbDatabases' existing = {
    name: 'mydb'
  }
}
//COSMOS

resource myapp 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'my-application'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

//MONGO
resource mongo 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'mongo-db'
  location: 'global'
  properties: {
    application: myapp.id
    environment: environmentId
    resource: cosmos::db.id
  }
}
//MONGO

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend-service'
  location: 'global'
  properties: {
    application: myapp.id
    //CONTAINER
    container: {
      image: 'nginx:latest'
    }
    //CONTAINER
    connections: {
      db: {
        source: mongo.id
      }
    }
  }
}
