import radius as radius

param location string = resourceGroup().location
param environment string

//PARAMETERS
param sqldb string
@secure()
param username string
@secure()
param password string
//PARAMETERS

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container'
  location: location
  properties: {
    environment: environment
  }
}

//DATABASE
resource db 'Applications.Connector/microsoftSqlDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    application: app.id
    resource: sqldb
  }
}
//DATABASE

//CONTAINER
resource webapp 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    application: app.id
    connections: {
      tododb: {
        kind: 'microsoft.com/SQL'
        source: db.id
      }
    }
    container: {
      image: 'rynowak/node-todo:latest'
      env: {
        DBCONNECTION: 'Data Source=tcp:${db.properties.server},1433;Initial Catalog=${db.properties.database};User Id=${username}@${db.properties.server};Password=${password};Encrypt=true'
      }
    }
  }
}
//CONTAINER
