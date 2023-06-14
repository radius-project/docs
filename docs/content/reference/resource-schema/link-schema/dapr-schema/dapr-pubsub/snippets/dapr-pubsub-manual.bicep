import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

@description('Mock account object.')
param account object

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'azure-resources-dapr-pubsub-generic'
  properties: {
    environment: environment
  }
}

resource publisher 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'publisher'
  properties: {
    application: app.id
    connections: {
      daprpubsub: {
        source: pubsub.id
      }
    }
    container: {
      image: 'radius.azurecr.io/magpie:latest'
    }
  }
}

resource kafkaRoute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' existing = {
  name: 'kafka-route'
}

//SAMPLE
resource pubsub 'Applications.Link/daprPubSubBrokers@2022-03-15-privatepreview' = {
  name: 'pubsub'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    resources: [
      { id: kafkaRoute.id }
    ]
    type: 'pubsub.kafka'
    metadata: {
      brokers: kafkaRoute.properties.url
      authRequired: false
      consumeRetryInternal: 1024
    }
    version: 'v1'
  }
}
//SAMPLE
