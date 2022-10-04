import radius as radius

param radEnvironment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

//REDIS
resource redis 'Applications.Connector/redisCaches@2022-03-15-privatepreview' = {
  name: 'redis'
  location: 'global'
  properties: {
    environment: radEnvironment
    application:app.id
    host: 'myredis.cluster.svc.local'
    port: 6679
    secrets: {
      connectionString: '**********'
      password: '**************'
    }
  }
}
//REDIS
