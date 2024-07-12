extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'dapr-pubsub'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource pubsub 'Applications.Dapr/pubSubBrokers@2023-10-01-preview' = {
  name: 'pubsub'
  properties: {
    environment: environment
    application: app.id
    recipe: {
      // Name a specific recipe to use
      name: 'azure-servicebus'
      // Set optional/required parameters (specific to the Recipe)
      parameters: {
        size: 'large'
      }
    }
  }
}
//SAMPLE
