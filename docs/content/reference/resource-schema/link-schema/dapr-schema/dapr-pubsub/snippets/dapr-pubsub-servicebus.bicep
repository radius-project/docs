import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-pubsub'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource pubsub 'Applications.Link/daprPubSubBrokers@2022-03-15-privatepreview' = {
  name: 'pubsub'
  properties: {
    environment: environment
    application: app.id
    mode: 'resource'
    resource: namespace.id
  }
}
//SAMPLE

//BICEP
resource namespace 'Microsoft.ServiceBus/namespaces@2017-04-01' = {
  name: 'ns-${uniqueString(resourceGroup().id)}'
}
//BICEP
