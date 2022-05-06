resource app 'radius.dev/Application@v1alpha3' = {
  name: 'dapr-tutorial'

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

  //BACKEND
  resource backend 'Container' = {
    name: 'backend'
    properties: {
      container: {
        image: 'radius.azurecr.io/daprtutorial-backend'
        ports: {
          orders: {
            containerPort: 3000
          }
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
  }
  //BACKEND

  //ROUTE
  resource daprBackend 'dapr.io.InvokeHttpRoute' = {
    name: 'dapr-backend'
    properties: {
      appId: 'backend'
    }
  }
  //ROUTE

  // Reference the Dapr state store deployed by the starter
  resource ordersStateStore 'dapr.io.StateStore' existing = {
    name: 'orders'
  }

}

// Use a starter module to deploy a Redis container and configure a Dapr state store
module stateStoreStarter 'br:radius.azurecr.io/starters/dapr-statestore:latest' = {
  name: 'orders-statestore-starter'
  params: {
    radiusApplication: app
    stateStoreName: 'orders'
  }
}
