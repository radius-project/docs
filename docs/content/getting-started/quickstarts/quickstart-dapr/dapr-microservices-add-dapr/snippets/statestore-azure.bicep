import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-quickstart'
  properties: {
    environment: environment
  }
}

//SAMPLE
@description('The geo-location where the resource lives.')
param location string = resourceGroup().location

resource stateStore 'Applications.Link/daprStateStores@2022-03-15-privatepreview' = {
  name: 'orders'
  properties: {
    environment: environment
    application: app.id
    mode: 'resource'
    resource: account::tableServices::table.id
  }
}

resource account 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'dapr${uniqueString(resourceGroup().id)}'
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
