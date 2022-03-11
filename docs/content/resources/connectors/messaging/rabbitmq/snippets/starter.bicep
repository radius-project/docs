resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  resource rabbitmqConnector 'rabbitmq.com.MessageQueue' existing = {
    name: 'orders'
  }
}

module rabbitMQ 'br:radius.azurecr.io/starters/rabbitmq:latest' = {
  name: 'rabbitmq'
  params: {
    radiusApplication: app
    queueName: 'orders'
  }
}
