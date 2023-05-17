import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//GATEWAY
resource gateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'gateway'
  properties: {
    application: app.id
    hostname: {
      // Omitting hostname properties results in gatewayname.appname.PUBLIC_HOSTNAME_OR_IP.nip.io
      
      // Results in prefix.appname.PUBLIC_HOSTNAME_OR_IP.nip.io
      prefix: 'prefix'
      // Alternately you can specify your own hostname that you've configured externally
      fullyQualifiedHostname: 'hostname.radapp.dev'
    }
    routes: [
      {
        path: '/frontend'
        destination: frontendroute.id
      }
      {
        path: '/backend'
        destination: backendroute.id
      }
    ]
    tls: {
      // Specify SSL Passthrough for your app (default: false)
      sslPassthrough: false

      // Specify TLS Termination for your app. Mutually exclusive with SSL Passthrough.
      // Hostname for TLS termination
      hostname: 'hostname.radapp.dev'
      // The Radius SecretStore holding TLS certificate data
      certificateFrom: secretstore.id
      // The minimum TLS protocol version to support. Defaults to 1.2
      minimumProtocolVersion: '1.2'
    }
  }
}
//GATEWAY

resource secretstore 'Applications.Core/secretStores@2022-03-15-privatepreview' = {
  name: 'secretstore'
  properties: {
    application: app.id
    data: {
    }
  }
}

//FRONTENDROUTE
resource frontendroute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'frontendroute'
  properties: {
    application: app.id
  }
}
//FRONTENDROUTE

//BACKENDROUTE
resource backendroute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'backendroute'
  properties: {
    application: app.id
  }
}
//BACKENDROUTE

//FRONTEND
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      ports: {
        http: {
          containerPort: 3000
          provides: frontendroute.id
        }
      }
      env: {
        BACKEND_URL: backendroute.properties.url
      }
    }
    connections: {
      backend: {
        source: backendroute.id
      }
    }
  }
}
//FRONTEND

//BACKEND
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      ports: {
        http: {
          containerPort: 8080
          provides: backendroute.id
        }
      }
    }
  }
}
//BACKEND
