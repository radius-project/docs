import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
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
param rmqPort string
param vHost string

resource rabbitmq 'Applications.Link/rabbitmqMessageQueues@2022-03-15-privatepreview' = {
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
