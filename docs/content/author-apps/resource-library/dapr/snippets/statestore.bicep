import radius as radius

param environmentId string


resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

//STATESTORE
resource azureTable 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-06-01' existing = {
  name: 'myaccount/default/mytable'
}

// The accompanying Dapr component configuration is automatically generated for you
resource stateStore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'mystatestore'
  location: 'global'
  properties: {
    environment: environmentId
    application: app.id
    kind: 'state.azure.tablestorage'
    resource: azureTable.id
  }
}
//STATESTORE
