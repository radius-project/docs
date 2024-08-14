extension radius

param environment string

@description('The Azure region to deploy Azure resource(s) into. Defaults to the region of the target Azure resource group.')
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

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'mycontainer'
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
