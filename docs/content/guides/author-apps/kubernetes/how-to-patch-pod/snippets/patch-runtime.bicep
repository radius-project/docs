import radius as radius

param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    RUNTIMES
    runtimes: {
      kubernetes: {
        pod: {
          containers: [
            {
              name: 'log-collector'
              image: 'radiusdev.azurecr.io/fluent/fluent-bit:2.1.8'
            }
          ]
          hostNetwork: true
        }
      }
    }
    RUNTIMES
  }
}
