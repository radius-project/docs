import radius as radius

param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment   
  }
}

//CONTAINER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'mycontainer'
  properties: {
    application: app.id
    container: {
      image: 'myimage'
      ports: {
        web: {
          containerPort: 80
        }
      }
    }
  }
}

//CONTAINER
resource statestore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
  name: 'inventory'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    type: 'state.azure.tablestorage'
    version: 'v1'
    metadata: {
      KEY: 'value'
    }
  }
}
