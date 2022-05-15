resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  //CONTAINER
  resource container 'Container' = {
    name: 'mycontainer'
    properties: {
      container: {
        image: 'myimage'
        ports: {
          web: {
            containerPort: 80
          }
        }
        volumes: {
          tmp: {
            kind: 'ephemeral'
            managedStore: 'memory'
            mountPath: '/tmp'
          }
        }
      }
      traits: [
        {
          kind: 'dapr.io/Sidecar@v1alpha1'
          appId: 'mycontainer'
        }
      ]
      connections: {
        statestore: {
          kind: 'dapr.io/StateStore'
          source: statestore.id
        }
      }
    }
  }
  //CONTAINER

  resource statestore 'dapr.io.StateStore' = {
    name: 'inventory'
    properties: {
      type: 'state.azure.tablestorage'
      kind: 'generic'
      version: 'v1'
      metadata: {
        KEY: 'value'
      }
    }
  }

}
