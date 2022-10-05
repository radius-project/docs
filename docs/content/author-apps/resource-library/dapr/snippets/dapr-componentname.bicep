import radius as rad

param environmentId string

resource table 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-09-01' existing = {
  name: 'myaccount/default/mytable'
}

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

//MARKER
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'myimage'
      env: {
        DAPR_COMPONENTNAME: statestore.properties.componentName
      }
    }
  }
}

//STATESTORE
resource statestore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'mystatestore'
  location: 'global'
  properties: {
    kind: 'state.azure.tablestorage'
    resource: table.id
    environment: environmentId
    application: app.id
  }
}
//STATESTORE
//MARKER
