import radius as radius

param location string = resourceGroup().location
param environment string

resource account 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: 'account-${guid(resourceGroup().name)}'
  location: location
  kind: 'MongoDB'
  //PROPERTIES
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
  //PROPERTIES

  resource mongodb 'mongodbDatabases' = {
    name: 'mydb'
    //PROPERTIES
    properties: {
      resource: {
        id: 'mydb'
      }
      options: {
        throughput: 400
      }
    }
    //PROPERTIES
  }
}

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    application: app.id
    resource: account::mongodb.id
  }
}
