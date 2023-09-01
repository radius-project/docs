import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource rabbitmq 'Applications.Messaging/rabbitmqQueues@2022-03-15-privatepreview' = {
  name: 'rabbitmq'
  properties: {
    environment: environment
    application: app.id
    recipe: {
      // Name a specific Recipe to use
      name: 'rabbit'
      // Optionally set recipe parameters if needed (specific to the Recipe)
      parameters: {
        queue: '*****'
      }
    }
  }
}
//SAMPLE

