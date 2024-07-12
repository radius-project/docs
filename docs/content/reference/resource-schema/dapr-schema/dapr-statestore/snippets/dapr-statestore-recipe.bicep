extension radius

@description('The app ID of your Radius Application. Set automatically by the rad CLI.')
param application string

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource myapp 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/magpiego:latest'
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
resource statestore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
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
