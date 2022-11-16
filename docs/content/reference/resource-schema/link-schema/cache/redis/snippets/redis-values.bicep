import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environment
  }
}

//REDIS
resource redis 'Applications.Link/redisCaches@2022-03-15-privatepreview' = {
  name: 'redis'
  location: 'global'
  properties: {
    environment: environment
    application:app.id
    mode: 'values'
    host: 'myredis.cluster.svc.local'
    port: 6679
    secrets: {
      connectionString: '**********'
      password: '**************'
    }
  }
}
//REDIS
