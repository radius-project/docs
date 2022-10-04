import radius as radius

param radEnvironment string
param location string = resourceGroup().location

resource cache 'Microsoft.Cache/Redis@2019-07-01' = {
  name: 'mycache'
  location: location
  properties: {
    sku: {
      capacity: 0
      family: 'C'
      name: 'Basic'
    }
  }
}

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: 'global'
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
        iam: {
          kind: 'azure'
          roles: [
            'Redis Cache Contributor'
          ]
        }
        source: cache.id
      }
    }
  }
}
