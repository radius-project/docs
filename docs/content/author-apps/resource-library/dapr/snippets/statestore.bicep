import radius as radius

param location string = resourceGroup().location
param environment string

resource azureTable 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-06-01' existing = {
  name: 'myaccount/default/mytable'
}

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

// The accompanying Dapr component configuration is automatically generated for you
resource stateStore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'mystatestore'
  location: location
  properties: {
    environment: environment
    application: app.id
    kind: 'state.azure.tablestorage'
    resource: azureTable.id
  }
}
