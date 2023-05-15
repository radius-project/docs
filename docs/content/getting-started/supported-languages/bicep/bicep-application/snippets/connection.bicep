import radius as radius

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
  properties: {
    environment: environment
  }
}

//MONGO
resource mongo 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'mongo-db'
  properties: {
    application: myapp.id
    environment: environment
    mode: 'resource'
    resource: cosmos::db.id
  }
}
//MONGO

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend-service'
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
