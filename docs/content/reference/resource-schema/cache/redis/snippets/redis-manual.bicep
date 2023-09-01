import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
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
resource redis 'Applications.Datastores/redisCaches@2022-03-15-privatepreview' = {
  name: 'redis'
  properties: {
    environment: environment
    application:app.id
    resourceProvisioning: 'manual'
    resources: [{
      id: azureRedis.id
    }]
    username: 'myusername'
    host: azureRedis.properties.hostName
    port: azureRedis.properties.port
    secrets: {
      password: azureRedis.listKeys().primaryKey
    }
  }
}
//REDIS
