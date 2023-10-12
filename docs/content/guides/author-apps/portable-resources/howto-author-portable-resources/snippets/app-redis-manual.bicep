import radius as radius

import kubernetes as kubernetes {
  kubeConfig: ''
  namespace: namespace
}

@description('Specifies the environment for resources.')
param environment string

@description('Specifies the application for resources.')
param application string

@description('Specifies the namespace for resources.')
param namespace string

//CONTAINER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
      ports: {
        web: {
          containerPort: 3000
        }
      }
      livenessProbe: {
        kind: 'httpGet'
        containerPort: 3000
        path: '/healthz'
        initialDelaySeconds: 10
      }
    }
    connections: {
      redis: {
        source: portableRedis.id
      }
    }
  }
}
//CONTAINER

//MANUAL
resource redis 'apps/Deployment@v1' = {
  metadata: {
    name: 'redis-${uniqueString(application)}'
  }
  spec: {
    selector: {
      matchLabels: {
        app: 'redis'
        resource: portableRedis.name
      }
    }
    template: {
      metadata: {
        labels: {
          app: 'redis'
          resource: portableRedis.name

          // Label pods with the application name so `rad run` can find the logs.
          'radapp.io/application': application == null ? '' : application
        }
      }
      spec: {
        containers: [
          {
            // This container is the running redis instance.
            name: 'redis'
            image: 'redis'
            ports: [
              {
                containerPort: 6379
              }
            ]
          }
          {
            // This container will connect to redis and stream logs to stdout for aid in development.
            name: 'redis-monitor'
            image: 'redis'
            args: [
              'redis-cli'
              '-h'
              'localhost'
              'MONITOR'
            ]
          }
        ]
      }
    }
  }
}

resource svc 'core/Service@v1' = {
  metadata: {
    name: 'redis-${uniqueString(application)}'
  }
  spec: {
    type: 'ClusterIP'
    selector: {
      app: 'redis'
      resource: portableRedis.name
    }
    ports: [
      {
        port: 6379
      }
    ]
  }
}

resource portableRedis 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'redisCache'
  properties: {
    environment: environment
    application: application
    resourceProvisioning: 'manual'
    resources: [{
      id: '/planes/kubernetes/local/namespaces/${svc.metadata.namespace}/providers/core/Service/${svc.metadata.name}'
    }
    {
      id: '/planes/kubernetes/local/namespaces/${redis.metadata.namespace}/providers/apps/Deployment/${redis.metadata.name}'
    }
    ]
    username: 'myusername'
    host: '${svc.metadata.name}.${svc.metadata.namespace}.svc.cluster.local'
    port: svc.ports[0].port
  }
}
//MANUAL
