import radius as radius

@description('Specifies the Radius environment for resources.')
param environment string

@description('Specifies the location for resources.')
param location string = 'global'

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'webapp'
  location: location
  properties: {
    environment: environment
  }
}

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
    }
    connections: {
      // Here you can see a frontend container talking to a Redis database, where the Redis database is using the `default` Recipe
      redis: {
        source: db.id
      }
    }
  }
}

// Redis Cache Link resource that utilizes a `default` Recipe
resource db 'Applications.Link/redisCaches@2022-03-15-privatepreview' = {
  name: 'db'
  location: location
  properties: {
    environment: environment
    application: app.id
  }
}
