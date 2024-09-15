extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'dapr-config'
  properties: {
    environment: environment
  }
}

resource myapp 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    application: app.id
    connections: {
      daprconfig: {
        source: config.id
      }
    }
    container: {
      image: 'ghcr.io/radius-project/magpiego:latest'
    }
  }
}

//SAMPLE
resource config 'Applications.Dapr/configurationStores@2023-10-01-preview' = {
  name: 'configstore'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    type: 'configuration.redis'
    metadata: {
      redisHost: {
        value: '<REDIS-URL>'
      }
      redisPassword: {
        value: ''
      }
    }
    version: 'v1'
  }
}
//SAMPLE
