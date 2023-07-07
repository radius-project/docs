//BACKEND
import radius as radius

@description('Specifies the environment for resources.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr'
  properties: {
    environment: environment
  }
}

// The backend container that is connected to the Dapr state store
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  properties: {
    application: app.id
    container: {
      // This image is where the app's backend code lives
      image: 'radius.azurecr.io/quickstarts/dapr-backend:edge'
      ports: {
        orders: {
          containerPort: 3000
        }
      }
    }
    connections: {
      orders: {
        source: stateStore.id
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'backend'
        appPort: 3000
      }
    ]
  }
}

@description('Specifies Kubernetes namespace for redis.')
param namespace string = 'default'

// The Dapr state store that is connected to the backend container
resource stateStore 'Applications.Link/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    type: 'state.redis'
    version: 'v1'
    metadata: {
      redisHost: '${service.metadata.name}.${namespace}.svc.cluster.local:${service.spec.ports[0].port}'
      redisPassword: ''
    }
  }
}

import kubernetes as kubernetes{
  kubeConfig: ''
  namespace: namespace
}

// The Redis statefulset and service that is used by the Dapr state store
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
//BACKEND

//FRONTEND
// The frontend container that serves the application UI
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      // This image is where the app's frontend code lives
      image: 'radius.azurecr.io/quickstarts/dapr-frontend:edge'
      ports: {
        ui: {
          containerPort: 80
        }
      }
    }
    // The extension to configure Dapr on the container, which is used to invoke the backend
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'frontend'
      }
    ]
  }
}

//FRONTEND
