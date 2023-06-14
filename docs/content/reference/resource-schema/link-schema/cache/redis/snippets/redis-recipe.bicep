import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//REDIS
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview' = {
  name: 'redis'
  properties: {
    environment: environment
    application:app.id
    recipe: {
      // Name a specific Recipe to use
      name: 'azure-redis'
      // Set optional/required parameters (specific to the Recipe)
      parameters: {
        port: '6379'
      }
    }
  }
}
//REDIS
