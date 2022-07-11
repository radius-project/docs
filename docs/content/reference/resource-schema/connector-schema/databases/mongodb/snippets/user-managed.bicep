import radius as radius

param location string = resourceGroup().location
param environment string

//BICEP
resource account 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: 'account-${guid(resourceGroup().name)}'
  location: resourceGroup().location
  kind: 'MongoDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: resourceGroup().location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
  }

  resource mongodb 'mongodbDatabases' = {
    name: 'mydb'
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
//BICEP

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container-usermanaged'
  location: location
  properties: {
    environment: environment
  }
}

//SAMPLE
resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    resource: account::mongodb.id
  }
}
//SAMPLE

resource webapp 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    application: app.id
    //HIDE
    container: {
      image: 'rynowak/node-todo:latest'
      env: {
        DBCONNECTION: db.id
      }
    }
    //HIDE
    connections: {
      mongo: {
        kind: 'mongo.com/MongoDB'
        source: db.id
        
      }
    }
  }
}
