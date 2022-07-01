param magpieimage string = 'radiusdev.azurecr.io/magpiego:latest'

param environment string

param location string = resourceGroup().location

//APPLICATION
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'corerp-resources-mongodb'
  location: 'global'
  properties: {
    environment: environment
  }
}
//APPLICATION

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: 'global'
  properties: {
    application: app.id
    connections: {
      mongodb: {
        source: dbconnector.id
      }
    }
    container: {
      image: 'myrepo/myimage'
    }
  }
}
//CONTAINER

//CONNECTOR
resource dbconnector 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'dbconnector'
  location: 'global'
  properties: {
    environment: environment
    resource: account::underlyingdb.id
  }
}
//CONNECTOR

//RESOURCE
resource account 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: 'account-${guid(resourceGroup().name)}'
  location: location
  kind: 'MongoDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
  }


  resource underlyingdb 'mongodbDatabases' = {
    name: 'mydb'
    properties: {
      resource: {
        id: 'mydb'
      }
    }
  }
}
//RESOURCE
