import radius as radius

param radEnvironment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

//SAMPLE
param rmqUsername string
@secure()
param rmqPassword string
param rmqHost string
param rmqPort string

resource rabbitmq 'Applications.Connector/rabbitmqMessageQueues@2022-03-15-privatepreview' = {
  name: 'rabbitmq'
  location: 'global'
  properties: {
    environment: radEnvironment
    application: app.id
    queue: 'radius-queue'
    secrets: {
      connectionString: 'amqp://${rmqUsername}:${rmqPassword}@${rmqHost}:${rmqPort}'
    }
  }
}
//SAMPLE
