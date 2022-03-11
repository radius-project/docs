  //SAMPLE

resource app 'radius.dev/Application@v1alpha3' = {
  name: 'shopping-app'

  resource store 'Container' = {
    name: 'storefront'
    properties: {
      //CONTAINER
      container: {
        image: 'radius.azurecr.io/storefront'
      }
      //CONTAINER
      connections: {
        inventory: {
          kind: 'dapr.io/StateStore'
          source: statestoreConnector.id
        }
      }
    }
  }

  resource statestoreConnector 'dapr.io.StateStore' existing = {
    name: 'inventory'
  }
}

module statestore 'br:radius.azurecr.io/starters/dapr-statestore-azure-tablestorage:latest' = {
  name: 'statestore'
  params: {
    radiusApplication: app
    stateStoreName: 'inventory'
  }
}
//SAMPLE
