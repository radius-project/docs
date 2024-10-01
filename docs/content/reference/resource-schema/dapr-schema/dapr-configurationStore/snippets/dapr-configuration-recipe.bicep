extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'dapr-configstore'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource configStore 'Applications.Dapr/configurationStores@2023-10-01-preview' = {
  name: 'configstore'
  properties: {
    environment: environment
    application: app.id
    recipe: {
      // Name a specific recipe to use
      name: 'azure-redis-with-config'
      // Set optional/required parameters (specific to the Recipe)
      parameters: {
        size: 'large'
      }
    }
  }
}
//SAMPLE
