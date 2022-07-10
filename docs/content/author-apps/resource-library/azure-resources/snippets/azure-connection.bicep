import radius as radius

param location string = resourceGroup().location
param environment string

resource cache 'Microsoft.Cache/Redis@2019-07-01' = {
  name: 'mycache'
  location: 'westus2'
  properties: {
    sku: {
      capacity: 0
      family: 'C'
      name: 'Basic'
    }
  }
}

resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'myimage'
      env: {
        REDIS_HOST: cache.properties.hostName
      }
    }
    connections: {
      redis: {
        kind: 'azure'
        source: cache.id
        roles: [
          'Redis Cache Contributor'
        ]
      }
    }
  }
}
