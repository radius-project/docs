import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

//SAMPLE
param rmqUsername string
param rmqPassword string
param rmqHost string
param rmqPort string

resource rabbitmq 'Applications.Connector/rabbitmqMessageQueues@2022-03-15-privatepreview' = {
  name: 'rabbitmq'
  location: location
  properties: {
    environment: environment
    application: app.id
    queue: 'radius-queue'
    secrets: {
      connectionString: 'amqp://${rmqUsername}:${rmqPassword}@${rmqHost}:${rmqPort}'
    }
  }
}
//SAMPLE
