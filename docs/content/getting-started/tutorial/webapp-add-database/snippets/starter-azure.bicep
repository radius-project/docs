import radius as radius

param environment string
param location string = resourceGroup().location
param accountName string = 'todoapp-cosmos-${uniqueString(resourceGroup().id)}'

//APP
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    environment: environment
  }
}
//APP

//CONTAINER
resource todoFrontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    //IMAGE
    container: {
      image: 'radius.azurecr.io/webapptutorial-todoapp'
    }
    //IMAGE
    connections: {
      mongodb: {
        source: db.id
      }
    }
  } 
}
//CONTAINER

resource db 'Applications.Connector/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    application: app.id
    resource: cosmosAccount::cosmosDb.id
  }
}

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: toLower(accountName)
  location: location
  kind: 'MongoDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
      }
    ]
  }
  

  resource cosmosDb 'mongodbDatabases' = {
    name: 'db'
    properties: {
      resource: {
        id: 'db'
      }
      options: {
        throughput: 400
      }
    }
  }

}
