import radius as radius

param location string = resourceGroup().location
param environment string

@description('Admin username for the RabbitMQ broker. Default is "guest"')
param username string = 'guest'

@description('Admin password for the RabbitMQ broker')
@secure()
param password string = newGuid()

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'kubernetes-resources-rabbitmq-managed'
  location: location
  properties: {
    environment: environment
  }
}

resource webapp 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    application: app.id
    //HIDE
    container: {
      image: 'radius.azurecr.io/magpie:latest'
      env: {
        BINDING_RABBITMQ_CONNECTIONSTRING: rabbitmq.connectionString()
      }
    }
    //HIDE
    connections: {
      messages: {
        kind: 'rabbitmq.com/MessageQueue'
        source: rabbitmq.id
      }
    }
  }
}

resource rabbitmqContainer 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'rmq-container'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'rabbitmq:3.9'
      ports: {
        rabbitmq: {
          containerPort: 5672
          provides: rmqContainer.id
        }
      }
    }
  }
}

resource rmqContainer 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'redis-route'
  location: location
  properties: {
    application: app.id
    port: 5672
  }
}

//SAMPLE
resource rabbitmq 'Applications.Connector/rabbitmqMessageQueues@2022-03-15-privatepreview' = {
  name: 'rabbitmq'
  location: location
  properties: {
    application: app.id
    queue: 'radius-queue'
    secrets: {
      connectionString: 'amqp://${username}:${password}@${rmqContainer.properties.host}:${rmqContainer.properties.port}'
    }
  }
}
//SAMPLE
