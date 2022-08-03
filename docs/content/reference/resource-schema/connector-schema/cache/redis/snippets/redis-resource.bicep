import radius as radius

param environment string
param location string = resourceGroup().id

param azureCacheId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

//REDIS
resource redis 'Applications.Connector/redisCaches@2022-03-15-privatepreview' = {
  name: 'redis'
  location: location
  properties: {
    environment: environment
    application: app.id
    resource: azureCacheId
  }
}
//REDIS
