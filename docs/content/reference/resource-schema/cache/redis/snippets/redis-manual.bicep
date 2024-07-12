extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource azureRedis 'Microsoft.Cache/redis@2022-06-01' existing = {
  name: 'mycache'
}

//REDIS
resource redis 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
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
