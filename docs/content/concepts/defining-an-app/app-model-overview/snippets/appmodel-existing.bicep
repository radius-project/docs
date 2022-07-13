import radius as radius

param location string = resourceGroup().location
param environment string

// Define existing, pre-deployed resources 
resource redis 'Microsoft.Cache/Redis@2019-07-01' existing = {
  name: 'myredis'
}

// Define services and connection to existing resource
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'app'
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
      image: 'myrepository/mycontainer:latest'
    }
    connections: {
      redis: {
        iam: {
          kind: 'azure'
          roles: [
            'Redis Cache Contributor'
          ]
        }
        source: redis.id
      }
    }
  }
}
