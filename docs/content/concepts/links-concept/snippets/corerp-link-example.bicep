import radius as radius

param environment string

param azureLocation string = 'westus3'

//APPLICATION
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'corerp-resources-mongodb'
  properties: {
    environment: environment
  }
}
//APPLICATION

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  properties: {
    application: app.id
    connections: {
      mongodb: {
        source: dblink.id
      }
    }
    container: {
      image: 'myrepo/myimage'
    }
  }
}
//CONTAINER

//LINK
resource dblink 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'dblink'
  properties: {
    environment: environment
    mode: 'resource'
    resource: account::underlyingdb.id
  }
}
//LINK

//RESOURCE
resource account 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: 'account-${guid(resourceGroup().name)}'
  location: azureLocation
  kind: 'MongoDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: azureLocation
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
  }


  resource underlyingdb 'mongodbDatabases' = {
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
//RESOURCE
