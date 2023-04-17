import radius as radius

param environment string

param azureCacheId string

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
    application: app.id
    mode: 'resource'
    resource: azureCacheId
  }
}
//REDIS
