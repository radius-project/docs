import radius as radius

param location string = resourceGroup().location
param environment string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'radcas${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  resource tableServices 'tableServices' = {
    name: 'default'

    resource table 'tables' = {
      name: 'dapr'
    }
  }
}

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'store'
  location: 'global'
  properties: {
    environment: environment
  }
}

resource stateStore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  location: 'global'
  properties: {
    environment: environment
    application: app.id
    kind: 'state.azure.tablestorage'
    resource: storageAccount::tableServices::table.id
  }
}
