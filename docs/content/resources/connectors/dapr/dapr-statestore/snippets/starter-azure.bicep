resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  resource stateStoreComponent 'dapr.io.StateStore' existing = {
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
