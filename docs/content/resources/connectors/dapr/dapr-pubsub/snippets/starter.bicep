resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  resource pubsubConnector 'dapr.io.PubSubTopic' existing = {
    name: 'orders'
  }
}

module pubsub 'br:radius.azurecr.io/starters/dapr-pubsub:latest' = {
  name: 'pubsub'
  params: {
    radiusApplication: app
    pubSubName: 'orders'
  }
}
