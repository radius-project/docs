import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-statestore'
  location: location
  properties: {
    environment: environment
  }
}

resource myapp 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/magpie:latest'
    }
    connections: {
      pubsub: {
        kind: 'dapr.io/StateStore'
        source: statestore.id
      }
    }
    traits: [
      {
        kind: 'dapr.io/Sidecar@v1alpha1'
        appId: 'myapp'
      }
    ]
  }
}
  
//SAMPLE
resource statestore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  location: location
  properties: {
    environment: environment
    application: app.id
    kind: 'state.sqlserver'
    resource: sqlserver.id
  }
}
//SAMPLE

//BICEP
resource sqlserver 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: 'sqlserver${uniqueString(resourceGroup().id)}'
  location:resourceGroup().location
  properties: {
    administratorLogin: 'user${uniqueString(resourceGroup().id)}'
    administratorLoginPassword: 'p@!!${uniqueString(resourceGroup().id)}'
    version: '12.0'
    minimalTlsVersion: '1.2'
  }
}
//BICEP
