import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'azure-resources-dapr-pubsub-generic'
  location: location
  properties: {
    environment: environment
  }
}

resource publisher 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'publisher'
  location: location
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
resource pubsub 'Applications.Connector/daprPubSubTopics@2022-03-15-privatepreview' = {
  name: 'pubsub'
  location: location
  properties: {
    environment: environment
    application: app.id
    kind: 'generic'
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
