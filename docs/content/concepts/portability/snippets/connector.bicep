import radius as radius

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
    container: {
      image: 'myrepo/myimage'
    }
    connections: {
      mongodb: {
        source: dbconnector.id
      }
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
    application: app.id
    resource: account::mongodb.id
  }
}
//CONNECTOR

//RESOURCE
resource account 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: 'account-${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'MongoDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
  }


  resource mongodb 'mongodbDatabases' = {
    name: 'mongodb'
    properties: {
      resource: {
        id: 'mydb'
      }
      options: { 
        throughput: 400
      }
    }
  }
}
//RESOURCE
