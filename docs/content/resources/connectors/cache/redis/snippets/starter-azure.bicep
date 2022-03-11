resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  resource redisConnector 'redislabs.com.RedisCache' existing = {
    name: 'inventory'
  }
}

module redis 'br:radius.azurecr.io/starters/redis-azure:latest' = {
  name: 'redis'
  params: {
    radiusApplication: app
    cacheName: 'inventory'
  }
}
