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

resource nodesubscriber 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'nodesubscriber'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'radiusteam/dapr-pubsub-nodesubscriber:latest'
      env: {
        SB_PUBSUBNAME: pubsub.properties.componentName
        SB_TOPIC: pubsub.properties.topic
      }
    }
    connections: {
      pubsub: {
        source: pubsub.id
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'nodesubscriber'
        appPort: 50051
      }
    ]
  }
}

resource pythonpublisher 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'pythonpublisher'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'radiusteam/dapr-pubsub-pythonpublisher:latest'
      env: {
        SB_PUBSUBNAME: pubsub.properties.componentName
        SB_TOPIC: pubsub.properties.topic
      }
    }
    connections: {
      pubsub: {
        source: pubsub.id
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'pythonpublisher'
      }
    ]
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
    resource: namespace::topic.id
  }
}
//SAMPLE

//BICEP
resource namespace 'Microsoft.ServiceBus/namespaces@2017-04-01' = {
  name: 'ns-${guid(resourceGroup().name)}'
  location: location
  resource topic 'topics' = {
    name: 'TOPIC_A'
  }
}
//BICEP
