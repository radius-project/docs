//KUBERNETES
import kubernetes as kubernetes {
  kubeConfig: ''
  namespace: context.runtime.kubernetes.namespace
}
//KUBERNETES

//PARAMETERS
@description('The port number that is used to connect to a Redis server.')
param port int = 6379

@description('The username that is used to connect to a Redis server.')
param username string = 'redis'

@secure()
@description('The password that is used to connect to a Redis server.')
param password string = ''
//PARAMETERS

//RESOURCE
@description('Radius-provided object containing information about the resource calling the Recipe')
param context object

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
            image: 'redis'
            ports: [
              {
                containerPort: port
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
    //PARAM
    ports: [
      {
        port: port
      }
    ]
    //PARAM
  }
}
//RESOURCE

//OUTPUT
output result object = {
  //LINKING
  // This workaround is needed because the deployment engine omits Kubernetes resources from its output.
  // Once this gap is addressed, users won't need to do this.
  resources: [
    '/planes/kubernetes/local/namespaces/${svc.metadata.namespace}/providers/core/Service/${svc.metadata.name}'
    '/planes/kubernetes/local/namespaces/${redis.metadata.namespace}/providers/apps/Deployment/${redis.metadata.name}'
  ]
  //LINKING
  values: {
    host: '${svc.metadata.name}.${svc.metadata.namespace}.svc.cluster.local'
    port: 6379 
    username: username
  }
  secrets: {
    #disable-next-line outputs-should-not-contain-secrets
    password: password
  }
}
//OUTPUT
