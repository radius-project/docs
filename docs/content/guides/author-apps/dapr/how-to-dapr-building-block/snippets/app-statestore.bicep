import radius as radius

@description('Specifies Kubernetes namespace for redis.')
param namespace string = 'default'

import kubernetes as kubernetes{
  kubeConfig: ''
  namespace: namespace
}

@description('The ID of your Radius Application. Automatically injected by the rad CLI.')
param application string

@description('The ID of your Radius environment. Set automatically by the rad CLI.')
param environment string

//CONTAINER
resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
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
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'demo'
        appPort: 3000
      }
    ]
     connections: {
      redis: {
        source: stateStore.id
      }
    }
  }
}
//CONTAINER

//STATESTORE
resource stateStore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
  name: 'statestore'
  properties: {
    environment: environment
    application: application
    resourceProvisioning: 'manual'
    type: 'state.redis'
    version: 'v1'
    metadata: {
      redisHost: '${service.metadata.name}.${namespace}.svc.cluster.local:${service.spec.ports[0].port}'
      redisPassword: ''
    }
  }
}

resource statefulset 'apps/StatefulSet@v1' = {
  metadata: {
    name: 'redis'
    labels: {
      app: 'redis'
    }
  }
  spec: {
    replicas: 1
    serviceName: service.metadata.name
    selector: {
      matchLabels: {
        app: 'redis'
      }
    }
    template: {
      metadata: {
        labels: {
          app: 'redis'
        }
      }
      spec: {
        automountServiceAccountToken: true
        terminationGracePeriodSeconds: 10
        containers: [
          {
            name: 'redis'
            image: 'redis:6.2'
            securityContext: {
              allowPrivilegeEscalation: false
            }
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

resource service 'core/Service@v1' = {
  metadata: {
    name: 'redis'
    labels: {
      app: 'redis'
    }
  }
  spec: {
    clusterIP: 'None'
    ports: [
      {
        port: 6379
      }
    ]
    selector: {
      app: 'redis'
    }
  }
}
//STATESTORE
