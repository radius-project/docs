import radius as radius

@description('The Azure region to deploy Azure resource(s) into. Defaults to the region of the target Azure resource group.')
param location string = resourceGroup().location

param environment string

//RESOURCE
resource azureRedis 'Microsoft.Cache/Redis@2019-07-01' = {
  name: 'myredis'
  location: location
  properties: {
    sku: {
      capacity: 0
      family: 'C'
      name: 'Basic'
    }
  }
}
//RESOURCE

resource app 'Applications.Core/applications@2022-03-15-privatepreview' existing = {
  name: 'myapp'
}

//LINK
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview' = {
  name: 'myredis-link'
  properties: {
    environment: environment
    application: app.id
    mode: 'resource'
    resource: azureRedis.id
  }
}
//LINK
//CONTAINER
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  properties: {
    application: app.id
    container: {
      image: 'myrepo/myimage'
    }
    connections: {
      inventory: {
        source: redis.id
      }
    }
  }
}
//CONTAINER
