//SAMPLE
resource app 'radius.dev/Application@v1alpha3' = {
  name: 'dapr-tutorial'

  //FRONTEND
  resource frontendGateway 'Gateway' = {
    name: 'gateway'
    properties: {
      routes: [
        {
          path: '/'
          destination: frontendRoute.id
        }
      ]
    }
  }
  
  resource frontendRoute 'HttpRoute' = {
    name: 'frontend-route'
  }
  
  resource frontend 'Container' = {
    name: 'frontend'
    properties: {
      container: {
        image: 'radius.azurecr.io/daprtutorial-frontend'
        ports:{
          ui: {
            containerPort: 80
            provides: frontendRoute.id
          }
        }
      }
      connections: {
        backend: {
          kind: 'dapr.io/InvokeHttp'
          source: daprBackend.id
        }
      }
      traits: [
        {
          kind: 'dapr.io/Sidecar@v1alpha1'
          appId: 'frontend'
        }
      ]
    }
  }
  //FRONTEND

  resource backend 'Container' = {
    name: 'backend'
    properties: {
      container: {
        image: 'radius.azurecr.io/daprtutorial-backend'
      }
      connections: {
        orders: {
          kind: 'dapr.io/StateStore'
          source: statestore.id
        }
      }
      traits: [
        {
          kind: 'dapr.io/Sidecar@v1alpha1'
          appId: 'backend'
          appPort: 3000
          provides: daprBackend.id
        }
      ]
    }
    dependsOn: [
      stateStoreStarter
    ]
  }

  resource daprBackend 'dapr.io.InvokeHttpRoute' = {
    name: 'backend-dapr'
    properties: {
      appId: 'backend'
    }
  }

  resource statestore 'dapr.io.StateStore' existing = {
    name: 'statestore'
  }
}

// Use a starter module to deploy a Redis container and configure a Dapr state store
module stateStoreStarter 'br:radius.azurecr.io/starters/dapr-statestore:latest' = {
  name: 'statestore-starter'
  params: {
    radiusApplication: app
    stateStoreName: 'statestore'
  }
}
