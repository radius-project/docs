extension radius

param environment string
param routeHostname string = 'nginx.example.com'

resource app 'Radius.Core/applications@2025-08-01-preview' = {
  name: 'nginx-radius-demo'
  properties: {
    environment: environment
  }
}

resource web 'Radius.Compute/containers@2025-08-01-preview' = {
  name: 'web'
  properties: {
    environment: environment
    application: app.id
    containers: {
      web: {
        image: 'nginx:alpine'
        ports: {
          http: {
            containerPort: 80
            protocol: 'TCP'
          }
        }
      }
    }
  }
}

resource route 'Radius.Compute/routes@2025-08-01-preview' = {
  name: 'web'
  properties: {
    environment: environment
    application: app.id
    kind: 'HTTP'
    hostnames: [
      routeHostname
    ]
    rules: [
      {
        matches: [
          {
            httpPath: '/'
          }
        ]
        destinationContainer: {
          resourceId: web.id
          containerName: 'web'
          containerPort: web.properties.containers.web.ports.http.containerPort
        }
      }
    ]
  }
}
