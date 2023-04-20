import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-quickstart'
  properties: {
    environment: environment
  }
}

//SAMPLE
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
