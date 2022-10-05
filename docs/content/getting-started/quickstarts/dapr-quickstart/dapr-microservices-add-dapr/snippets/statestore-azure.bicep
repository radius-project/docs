import radius as radius

param location string = resourceGroup().location
param environmentId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-quickstart'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

//SAMPLE
resource stateStore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'orders'
  location: 'global'
  properties: {
    environment: environmentId
    application: app.id
    kind: 'state.azure.tablestorage'
    resource: account::tableServices::table.id
  }
}

resource account 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'daprquickstart${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }

  resource tableServices 'tableServices' = {
    name: 'default'

    resource table 'tables' = {
      name: 'dapr'
    }
  }
}
//SAMPLE
