import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource azureRedis 'Microsoft.Cache/redis@2022-06-01' existing = {
  name: 'mycache'
}

//REDIS
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview' = {
  name: 'redis'
  properties: {
    environment: environment
    application:app.id
    resourceProvisioning: 'manual'
    resources: [{
      id: azureRedis.id
    }]
    host: azureRedis.properties.hostName
    port: azureRedis.properties.port
    secrets: {
      password: azureRedis.listKeys().primaryKey
    }
  }
}
//REDIS
