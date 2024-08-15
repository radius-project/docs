extension radius

param environment string

resource account 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: 'myaccount'

  resource tableServices 'tableServices' existing = {
    name: 'default'

    resource table 'tables' existing = {
      name: 'mytable'
    }
  }
}

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//MARKER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'mycontainer'
  properties: {
    application: app.id
    container: {
      image: 'myimage'
      env: {
        // Option 1: Manually set component name as an environment variable
        DAPR_COMPONENTNAME: statestore.name
      }
    }
    connections: {
      // Option 2 (preferred): Automatically set environment variable with component name
      c1: {
        source: statestore.id // Results in CONNECTION_C1_COMPONENTNAME
      }
    }
  }
}

//STATESTORE
resource statestore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
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
//MARKER
