import radius as radius

param radEnvironment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

//GATEWAY
resource gateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'gateway'
  location: 'global'
  properties: {
    application: app.id
    hostname: {
      // Ommiting hostname properties results in gatewayname.appname.PUBLIC_HOSTNAME_OR_IP.nip.io
      
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
  }
}
//GATEWAY

//FRONTENDROUTE
resource frontendroute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'frontendroute'
  location: 'global'
  properties: {
    application: app.id
  }
}
//FRONTENDROUTE

//BACKENDROUTE
resource backendroute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'backendroute'
  location: 'global'
  properties: {
    application: app.id
  }
}
//BACKENDROUTE

//FRONTEND
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: 'global'
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
  location: 'global'
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
