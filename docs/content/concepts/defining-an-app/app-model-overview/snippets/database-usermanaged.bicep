import radius as radius

param location string = resourceGroup().location
param environment string

resource account 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: 'account-${guid(resourceGroup().name)}'
  location: resourceGroup().location
  kind: 'MongoDB'
  //PROPERTIES
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

resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'
  location: location
}

  resource db 'mongo.com.MongoDatabase' = {
    name: 'db'
    location: location
    properties: {
      resource: account::mongodb.id
    }
  }

}
