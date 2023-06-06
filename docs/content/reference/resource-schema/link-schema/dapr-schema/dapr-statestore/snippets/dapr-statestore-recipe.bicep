import radius as radius


param application string
param environment string

resource myapp 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/magpie:latest'
    }
    connections: {
      statestore: {
        source: statestore.id
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'myapp'
      }
    ]
  }
}
  
//SAMPLE
resource statestore 'Applications.Link/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  properties: {
    environment: environment
    application: application
  }
}
//SAMPLE

