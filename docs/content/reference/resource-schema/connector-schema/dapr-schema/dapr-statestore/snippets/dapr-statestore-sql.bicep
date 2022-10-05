import radius as radius

param location string = resourceGroup().location
param environmentId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-statestore'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

resource myapp 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/magpie:latest'
    }
    connections: {
      pubsub: {
        source: statestore.id
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'myapp'
      }
    ]
  }
}
  
//SAMPLE
resource statestore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  location: 'global'
  properties: {
    environment: environmentId
    application: app.id
    kind: 'state.sqlserver'
    resource: sqlserver.id
  }
}
//SAMPLE

//BICEP
resource sqlserver 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: 'sqlserver${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    administratorLogin: 'user${uniqueString(resourceGroup().id)}'
    administratorLoginPassword: 'p@!!${uniqueString(resourceGroup().id)}'
    version: '12.0'
    minimalTlsVersion: '1.2'
  }
}
//BICEP
