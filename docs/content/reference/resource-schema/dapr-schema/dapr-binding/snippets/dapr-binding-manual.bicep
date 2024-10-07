extension radius

param magpieimage string
param environment string
param namespace string = 'default'
param baseName string = 'dbd-manual'

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: baseName
  properties: {
    environment: environment
  }
}

resource myapp 'Applications.Core/containers@2023-10-01-preview' = {
  name: '${baseName}-ctnr'
  properties: {
    application: app.id
    connections: {
      daprbinding: {
        source: binding.id
      }
    }
    container: {
      image: magpieimage
      readinessProbe: {
        kind: 'httpGet'
        containerPort: 3000
        path: '/healthz'
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'dbd-manual-ctnr'
        appPort: 3000
      }
    ]
  }
}

//SAMPLE
resource binding 'Applications.Dapr/bindings@2023-10-01-preview' = {
  name: 'outredis'
  properties: {
    application: app.id
    environment: environment
    resourceProvisioning: 'manual'
    type: 'bindings.redis'
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
