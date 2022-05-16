resource azureTable 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-06-01' existing = {
  name: 'myaccount/default/mytable'
}

resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  // The accompanying Dapr component configuration is automatically generated for you
  resource stateStore 'dapr.io.StateStore' = {
    name: 'mystatestore'
    properties: {
      kind: 'state.azure.tablestorage'
      resource: azureTable.id
    }
  }

}
