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
resource portableRedis 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'redisCache'
  properties: {
    environment: environment
    application: application
    resourceProvisioning: 'manual'
    resources: [{
      id: '/planes/kubernetes/local/namespaces/service-namespace/providers/core/Service/service-name'
    }
    {
      id: '/planes/kubernetes/local/namespaces/redis-namespace/providers/apps/Deployment/redis-name'
    }
    ]
    username: 'myusername'
    host: 'mycache.contoso.com'
    port: 8080
    secrets: {
      password: '******'
    }
  }
}
//MANUAL
