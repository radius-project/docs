import radius as radius

param application string
param environment string

//SAMPLE
resource statestore 'Applications.Link/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  properties: {
    environment: environment
    application: application
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
//SAMPLE


resource account 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: 'myaccount'

  resource tableServices 'tableServices' existing = {
    name: 'default'

    resource table 'tables' existing = {
      name: 'mytable'
    }
  }
}
