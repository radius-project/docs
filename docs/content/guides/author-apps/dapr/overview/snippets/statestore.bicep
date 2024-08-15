extension radius

param environment string


resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//STATESTORE
resource account 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: 'myaccount'

  resource tableServices 'tableServices' existing = {
    name: 'default'

    resource table 'tables' existing = {
      name: 'mytable'
    }
  }
}

// The accompanying Dapr component resource is automatically created for you
resource stateStore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
  name: 'mystatestore'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    resources: [
      { id: account.id }
      { id: account::tableServices::table.id }
    ]
    metadata: {
      accountName: account.name
      accountKey: account.listKeys().keys[0].value
      tableName: account::tableServices::table.name
    }
    type: 'state.azure.tablestorage'
    version: 'v1'
  }
}
//STATESTORE
