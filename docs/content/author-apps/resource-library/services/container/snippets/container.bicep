import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environment   
  }
}

//CONTAINER
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'myimage'
      ports: {
        web: {
          containerPort: 80
        }
      }
      volumes: {
        tmp: {
          kind: 'ephemeral'
          managedStore: 'memory'
          mountPath: '/tmp'
        }
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'mycontainer'
      }
    ]
    connections: {
      statestore: {
        source: statestore.id
      }
    }
  }
}

//CONTAINER
resource statestore 'Applications.Link/daprStateStores@2022-03-15-privatepreview' = {
  name: 'inventory'
  location: 'global'
  properties: {
    environment: environment
    application: app.id
    mode: 'values'
    type: 'state.azure.tablestorage'
    kind: 'generic'
    version: 'v1'
    metadata: {
      KEY: 'value'
    }
  }
}
