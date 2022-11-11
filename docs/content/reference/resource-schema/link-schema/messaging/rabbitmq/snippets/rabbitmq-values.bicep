import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environment
  }
}

//SAMPLE
param rmqUsername string
@secure()
param rmqPassword string
param rmqHost string
param rmqPort string

resource rabbitmq 'Applications.Link/rabbitmqMessageQueues@2022-03-15-privatepreview' = {
  name: 'rabbitmq'
  location: 'global'
  properties: {
    environment: environment
    application: app.id
    mode: 'values'
    queue: 'radius-queue'
    secrets: {
      connectionString: 'amqp://${rmqUsername}:${rmqPassword}@${rmqHost}:${rmqPort}'
    }
  }
}
//SAMPLE
