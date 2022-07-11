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
    kind: 'state.azure.tablestorage'
    resource: storageAccount::tablestorage.id
  }
}
//SAMPLE

//BICEP
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'sa-${guid(resourceGroup().name)}'
  location: resourceGroup().location
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
