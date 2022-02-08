resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'
}
module statestore 'br:radius.azurecr.io/starters/dapr-statestore:latest' = {
  name: 'statestore'
  params: {
    radiusApplication: app
    stateStoreName: 'inventory'
  }
}
