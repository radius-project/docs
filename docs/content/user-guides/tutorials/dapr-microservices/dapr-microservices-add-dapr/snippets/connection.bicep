resource app 'radius.dev/Application@v1alpha3' = {
  name: 'dapr-tutorial'

  resource backend 'Container' = {
    name: 'backend'
    properties: {
      //CONTAINER
      container: {
        image: 'radius.azurecr.io/daprtutorial-backend'
        ports: {
          orders: {
            containerPort: 3000
          }
        }
      }
      //CONTAINER
      connections: {
        statestore: {
          kind: 'dapr.io/StateStore'
          source: ordersStateStore.id
        }
      }
      //TRAITS
      traits: [
        {
          kind: 'dapr.io/Sidecar@v1alpha1'
          appId: 'backend'
          appPort: 3000
          provides: daprBackend.id
        }
      ]
      //TRAITS
    }
    // Temporary requirement - will be removed in a future release
    dependsOn: [
      stateStoreStarter
    ]
  }

  //ROUTE
  resource daprBackend 'dapr.io.InvokeHttpRoute' = {
    name: 'dapr-backend'
    properties: {
      appId: 'backend'
    }
  }
  //ROUTE

  //CONNECTOR
  // Temporary requirement - will be removed in a future release
  resource ordersStateStore 'dapr.io.StateStore' existing = {
    name: 'orders'
  }
  //CONNECTOR

}

//STARTER
module stateStoreStarter 'br:radius.azurecr.io/starters/dapr-statestore:latest' = {
  name: 'orders-statestore-starter'
  params: {
    radiusApplication: app
    stateStoreName: 'orders'
  }
}
//STARTER
