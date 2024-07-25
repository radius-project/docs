//PARAMETERS
@description('The port Redis is offered on. Defaults to 6379.')
param port int = 6379
//PARAMETERS

//RESOURCE
@description('Radius-provided object containing information about the resource calling the Recipe')
param context object

// Import Kubernetes resources into Bicep
extension kubernetes with {
  kubeConfig: ''
  namespace: context.runtime.kubernetes.namespace
}

resource redis 'apps/Deployment@v1' = {
  metadata: {
    // Ensure the resource name is unique and repeatable
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
            image: 'redis:6'
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
        port: port
        targetPort: '6379'
      }
    ]
  }
}
//RESOURCE

//OUTPUT
@description('The result of the Recipe. Must match the target resource\'s schema.')
output result object = {
  values: {
    host: '${svc.metadata.name}.${svc.metadata.namespace}.svc.cluster.local'
    port: svc.spec.ports[0].port
    username: ''
  }
  secrets: {
    // Temporarily disable linter until secret outputs are added
    #disable-next-line outputs-should-not-contain-secrets
    password: ''
  }
  // UCP IDs for the above Kubernetes resources
  resources: [
    '/planes/kubernetes/local/namespaces/${svc.metadata.namespace}/providers/core/Service/${svc.metadata.name}'
    '/planes/kubernetes/local/namespaces/${redis.metadata.namespace}/providers/apps/Deployment/${redis.metadata.name}'
  ]
}
//OUTPUT
