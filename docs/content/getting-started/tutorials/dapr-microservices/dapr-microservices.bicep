resource app 'radius.dev/Application@v1alpha3' = {
  name: 'dapr-hello'

  resource nodeapplication_dapr 'dapr.io.InvokeHttpRoute' = {
    name: 'nodeapp'
    properties: {
      appId: 'nodeapp'
    }
  }

  resource nodeapplication 'Container' = {
    name: 'nodeapp'
    properties: {
      connections: {
        statestore: {
          kind: 'dapr.io/StateStore'
          source: statestore.id
        }
      }
      container: {
        image: 'radiusteam/tutorial-nodeapp'
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
      traits: [
        {
          kind: 'dapr.io/Sidecar@v1alpha1'
          provides: nodeapplication_dapr.id
          appId: 'nodeapp'
          appPort: 3000
        }
      ]
    }
    dependsOn: [
      stateStoreStarter
    ]
  }

  resource pythonapplication 'Container' = {
    name: 'pythonapp'
    properties: {
      connections: {
        nodeapp: {
          kind: 'dapr.io/InvokeHttp'
          source: nodeapplication_dapr.id
        }
      }
      container: {
        image: 'radiusteam/tutorial-pythonapp'
      }
      traits: [
        {
          kind: 'dapr.io/Sidecar@v1alpha1'
          appId: 'pythonapp'
        }
      ]
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
