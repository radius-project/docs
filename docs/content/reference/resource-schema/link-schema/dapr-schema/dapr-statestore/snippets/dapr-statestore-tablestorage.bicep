import radius as radius

@description('The Azure region to deploy Azure resource(s) into. Defaults to the region of the target Azure resource group.')
param location string = resourceGroup().location

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-statestore'
  properties: {
    environment: environment
  }
}

resource myapp 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'myapp'
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
resource statestore 'Applications.Link/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  properties: {
    environment: environment
    application: app.id
    mode: 'resource'
    resource: storageAccount::tablestorage.id
  }
}
//SAMPLE

//BICEP
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'sa-${guid(resourceGroup().name)}'
  location:location
  sku: {
    name: 'Standard_ZRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }

  resource tablestorage 'tableServices' = {
    name: 'default'
  }
}
//BICEP
