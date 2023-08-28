//RESOURCE
import kubernetes as kubernetes {
  kubeConfig: '*****'
  namespace: 'default'
}
import radius as radius

param environment string

resource redisPod 'core/Pod@v1' = {
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

//PORTABLE RESOURCE
resource redis 'Applications.Datastores/redisCaches@2022-03-15-privatepreview' = {
  name: 'myrediscache'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    host: redisPod.spec.hostname
    port: redisPod.spec.containers[0].ports[0].containerPort
    secrets: {
      connectionString: '${redisPod.spec.hostname}.svc.cluster.local:${redisPod.spec.containers[0].ports[0].containerPort}'
      password: ''
    }
  }
}
//PORTABLE RESOURCE
//CONTAINER
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
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
