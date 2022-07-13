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

resource app 'Applications.Core/applications@2022-03-15-privatepreview' existing = {
  name: 'myapp'
}

//CONNECTOR
resource redis 'Applications.Connector/redisCache@2022-03-15-privatepreview' = {
  name: 'myredis-connector'
  location: location
  properties: {
    environment: environment
    application: app.id
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
    application: app.id
    container: {
      image: 'myrepo/myimage'
    }
    connections: {
      inventory: {
        source: redis.id
      }
    }
  }
}
//CONTAINER
