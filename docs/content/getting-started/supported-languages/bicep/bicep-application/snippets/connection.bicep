import radius as radius

param location string = resourceGroup().location
param environment string

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
  location: location
  properties: {
    environment: environment
  }
}

//MONGO
resource mongo 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'mongo-db'
  location: location
  properties: {
    application: myapp.id
    resource: cosmos::db.id
  }
}
//MONGO

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend-service'
  location: location
  properties: {
    application: myapp.id
    //CONTAINER
    container: {
      image: 'nginx:latest'
    }
    //CONTAINER
    connections: {
      db: {
        kind: 'mongo.com/MongoDB'
        source: mongo.id
      }
    }
  }
}
