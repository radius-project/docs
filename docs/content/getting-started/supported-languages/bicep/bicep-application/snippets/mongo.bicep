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
  location: 'global'
  properties: {
    environment: environment
  }
}

resource mongo 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'mongo-db'
  location: 'global'
  properties: {
    application: myapp.id
    environment: environment
    resource: cosmos::db.id
  }
}
