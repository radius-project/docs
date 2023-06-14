import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-secretstore-generic'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource secretstore 'Applications.Link/daprSecretStores@2022-03-15-privatepreview' = {
  name: 'secretstore-generic'
  properties: {
    environment: environment
    application: app.id
    recipe: {
      // Name a specific Recipe to use
      name: 'secret-prod'
      // Set optional/required parameters (specific to the Recipe)
      parameters: {
        version: 'v1'
      }
    }
  }
}
//SAMPLE
