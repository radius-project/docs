import radius as radius

@description('The app ID of your Radius application. Set automatically by the rad CLI.')
param application string

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
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
    recipe: {
      // Name a specific Recipe to use
      name: 'azure-redis'
      // Optionally set recipe parameters if needed (specific to the Recipe)
      parameters: {
        // ....
      }
    }
  }
}
//SAMPLE

