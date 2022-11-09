import radius as radius

param environment string


resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environment
  }
}

//STATESTORE
resource azureTable 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-06-01' existing = {
  name: 'myaccount/default/mytable'
}

// The accompanying Dapr component configuration is automatically generated for you
resource stateStore 'Applications.Link/daprStateStores@2022-03-15-privatepreview' = {
  name: 'mystatestore'
  location: 'global'
  properties: {
    environment: environment
    application: app.id
    kind: 'state.azure.tablestorage'
    mode: 'resource'
    resource: azureTable.id
  }
}
//STATESTORE
