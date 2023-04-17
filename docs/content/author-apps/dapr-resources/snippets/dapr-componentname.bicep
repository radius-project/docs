import radius as rad

param environment string

resource table 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-09-01' existing = {
  name: 'myaccount/default/mytable'
}

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//MARKER
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
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
resource statestore 'Applications.Link/daprStateStores@2022-03-15-privatepreview' = {
  name: 'mystatestore'
  properties: {
    mode: 'resource'
    resource: table.id
    environment: environment
    application: app.id
  }
}
//STATESTORE
//MARKER
