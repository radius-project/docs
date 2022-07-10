import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'store'
  location: location
  properties: {
    environment: environment
  }
}

resource redisContainer 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'redis-container'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'redis:6.2'
      ports: {
        redis: {
          containerPort: 6379
          provides: redisRoute.id
        }
      }
    }
  }
}

resource redisRoute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'redis-route'
  location: location
  properties: {
    application: app.id
    port: 6379
  }
}

resource stateStore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  location: location
  properties: {
    application: app.id
    kind: 'generic'
    type: 'state.redis'
    version: 'v1'
    metadata: {
      redisHost: '${redisRoute.properties.host}:${redisRoute.properties.port}'
      redisPassword: ''
    }
  }
}
