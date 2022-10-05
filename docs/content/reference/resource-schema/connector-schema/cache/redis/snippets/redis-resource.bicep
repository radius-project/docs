import radius as radius

param environmentId string

param azureCacheId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

//REDIS
resource redis 'Applications.Connector/redisCaches@2022-03-15-privatepreview' = {
  name: 'redis'
  location: 'global'
  properties: {
    environment: environmentId
    application: app.id
    resource: azureCacheId
  }
}
//REDIS
