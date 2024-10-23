extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'dapr-binding'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource binding 'Applications.Dapr/bindings@2023-10-01-preview' = {
  name: 'binding'
  properties: {
    environment: environment
    application: app.id
    recipe: {
      // Name a specific recipe to use
      name: 'smtp-server-binding'
      // Set optional/required parameters (specific to the Recipe)
      parameters: {
        validateHtml: true
      }
    }
  }
}
//SAMPLE
