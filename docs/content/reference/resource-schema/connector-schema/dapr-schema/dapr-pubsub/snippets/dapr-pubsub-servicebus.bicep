import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-pubsub'
  location: 'global'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource pubsub 'Applications.Connector/daprPubSubBrokers@2022-03-15-privatepreview' = {
  name: 'pubsub'
  location: 'global'
  properties: {
    environment: environment
    application: app.id
    kind: 'pubsub.azure.servicebus'
    resource: namespace.id
  }
}
//SAMPLE

//BICEP
resource namespace 'Microsoft.ServiceBus/namespaces@2017-04-01' = {
  name: 'ns-${uniqueString(resourceGroup().id)}'
  location: location
}
//BICEP
