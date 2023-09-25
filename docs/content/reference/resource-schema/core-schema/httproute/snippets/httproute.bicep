import radius as radius

param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//HTTPROUTE
resource httproute 'Applications.Core/httpRoutes@2023-10-01-preview' = {
  name: 'httproute'
  properties: {
    application: app.id
  }
}
//HTTPROUTE

//FRONTEND
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      env: {
        BACKEND_URL: httproute.properties.url
      }
    }
    connections: {
      http: {
        source: httproute.id
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
          containerPort: 80
          provides: httproute.id
        }
      }
    }
  }
}
//BACKEND
