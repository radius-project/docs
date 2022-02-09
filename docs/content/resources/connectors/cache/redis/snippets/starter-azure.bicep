resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  resource container 'Container' = {
    name: 'mycontainer'
    properties: {
      container: {
        image: 'myregistry/myimage'
        env: {
          REDIS_CS: redis.outputs.redisCache.connectionString()
        }
      }
      connections: {
        cache: {
          kind: 'redislabs.com/Redis'
          source: redis.outputs.redisCache.id
        }
      }
    }
  }

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
