extension radius

param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//GATEWAY
resource gateway 'Applications.Core/gateways@2023-10-01-preview' = {
  name: 'gateway'
  properties: {
    application: app.id
    hostname: {
      // Omitting hostname properties results in gatewayname.appname.PUBLIC_HOSTNAME_OR_IP.nip.io

      // Results in prefix.appname.PUBLIC_HOSTNAME_OR_IP.nip.io
      prefix: 'prefix'
      // Alternately you can specify your own hostname that you've configured externally
      fullyQualifiedHostname: 'hostname.radapp.io'
    }
    routes: [
      {
        path: '/frontend'
        destination: 'http://${frontend.name}:3000'
      }
      {
        path: '/backend'
        destination: 'http://${backend.name}:8080'

        // Enable websocket support for the route (default: false)
        enableWebsockets: true
      }
    ]
    tls: {
      // Specify SSL Passthrough for your app (default: false)
      sslPassthrough: false

      // The Radius Secret Store holding TLS certificate data
      certificateFrom: secretstore.id
      // The minimum TLS protocol version to support. Defaults to 1.2
      minimumProtocolVersion: '1.2'
    }
  }
}
//GATEWAY

resource secretstore 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'secretstore'
  properties: {
    application: app.id
    data: {
    }
  }
}

//FRONTEND
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      ports: {
        http: {
          containerPort: 3000
        }
      }
    }
    connections: {
      backend: {
        source: 'http://backend:8080'
      }
    }
  }
}
//FRONTEND

//BACKEND
resource backend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'backend'
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      ports: {
        http: {
          containerPort: 8080
        }
      }
    }
  }
}
//BACKEND
