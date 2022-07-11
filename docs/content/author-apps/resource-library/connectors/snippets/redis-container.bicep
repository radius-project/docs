//RESOURCE
import kubernetes as kubernetes
import radius as radius

param location string = resourceGroup().location
param environment string

resource redisPod 'kubernetes.core/Pod@v1' = {
  metadata: {
    name: 'redis'
  }
  spec: {
    containers: [
      {
        name: 'redis:6.2'
        ports: [
          {
            containerPort: 6379
          }
        ]
      }
    ]
  }
}
//RESOURCE

resource app 'radius.dev/Application@v1alpha3' existing = {
  name: 'myapp'
}

//CONNECTOR
resource redis 'Applications.Connector/redisCache@2022-03-15-privatepreview' = {
  name: 'myredis-connector'
  location: location
  properties: {
    environment: environment
    host: redisPod.spec.hostname
    port: redisPod.spec.containers[0].ports[0].containerPort
    secrets: {
      connectionString: '${redisPod.spec.hostname}.svc.cluster.local:${redisPod.spec.containers[0].ports[0].containerPort}'
      password: ''
    }
  }
}
//CONNECTOR
//CONTAINER
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: location
  properties: {
    environment: environment
    container: {
      image: 'myrepo/myimage'
    }
    connections: {
      inventory: {
        kind: 'redislabs.com/Redis'
        source: redis.id
      }
    }
  }
}
//CONTAINER
