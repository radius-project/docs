extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'dapr-secretstore-generic'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource secretstore 'Applications.Dapr/secretStores@2023-10-01-preview' = {
  name: 'secretstore-generic'
  properties: {
    environment: environment
    application: app.id
    recipe: {
      // Name a specific Recipe to use
      name: 'secret-provider'
      // Optionally set recipe parameters if needed (specific to the Recipe)
      parameters: {
        // ....
      }
    }
  }
}
//SAMPLE
