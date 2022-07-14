import radius as radius

param environmentId string

param location string = resourceGroup().location

param accountName string = 'todoapp-cosmos-${uniqueString(resourceGroup().id)}'

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    environment: environmentId
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
