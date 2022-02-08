resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'
}

module pubsub 'br:radius.azurecr.io/starters/dapr-pubsub:latest' = {
  name: 'pubsub'
  params: {
    radiusApplication: app
    pubSubName: 'orders'
  }
}
