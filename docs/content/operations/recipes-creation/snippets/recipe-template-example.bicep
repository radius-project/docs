import kubernetes as kubernetes {
  kubeConfig: ''
  namespace: context.runtime.kubernetes.namespace
}
//CONTEXT
param context object
//CONTEXT
//CUSTOMPARAM
@description('A custom parameter that can be set by a developer or operator')
param memoryDBCluster object
//CUSTOMPARAM

//INFRA
resource redis 'apps/Deployment@v1' = {
  metadata: {
    name: 'redis-${uniqueString(context.resource.id)}'
  }
  spec: {
    selector: {
      matchLabels: {
        app: 'redis'
        resource: context.resource.name
      }
    }
    template: {
      metadata: {
        labels: {
          app: 'redis'
          resource: context.resource.name
        }
      }
      spec: {
        containers: [
          {
            name: 'redis'
            image: 'redis'
            ports: [
              {
                containerPort: 6379
              }
            ]
          }
        ]
      }
    }
  }
}

resource svc 'core/Service@v1' = {
  metadata: {
    name: 'redis-${uniqueString(context.resource.id)}'
  }
  spec: {
    type: 'ClusterIP'
    selector: {
      app: 'redis'
      resource: context.resource.name
    }
    ports: [
      {
        port: 6379
      }
    ]
  }
}
//INFRA

//RESOURCEOBJECT
resource azureCache 'Microsoft.Cache/redis@2022-06-01' = {
  name: 'cache'
  location: 'global'
  properties: {
    sku: {
      capacity: 1
      family: 'C'
      name: ''
    }
  }
}

output resource string = azureCache.id
//RESOURCEOBJECT




//OUTPUT
output result object = {
  resources: [
    '/planes/kubernetes/local/namespaces/${svc.metadata.namespace}/providers/core/Service/${svc.metadata.name}'
    '/planes/kubernetes/local/namespaces/${redis.metadata.namespace}/providers/apps/Deployment/${redis.metadata.name}'
  ]
  values: {
    host: '${svc.metadata.name}.${svc.metadata.namespace}.svc.cluster.local'
    port: 6379
  }
  secrets: {
    connectionString: 'redis://${memoryDBCluster.properties.ClusterEndpoint.Address}:${memoryDBCluster.properties.ClusterEndpoint.Port}'
    password: ''
  }
}
//OUTPUT
