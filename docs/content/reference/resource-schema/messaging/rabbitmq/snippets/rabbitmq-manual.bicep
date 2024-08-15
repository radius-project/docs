extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//SAMPLE
param rmqUsername string
@secure()
param rmqPassword string
param rmqHost string
param rmqPort int
param vHost string

resource rabbitmq 'Applications.Messaging/rabbitmqQueues@2023-10-01-preview' = {
  name: 'rabbitmq'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    queue: 'radius-queue'
    host: rmqHost
    port: rmqPort
    vHost: vHost
    username: rmqUsername
    secrets: {
      password: rmqPassword
    }
  }
}
//SAMPLE
