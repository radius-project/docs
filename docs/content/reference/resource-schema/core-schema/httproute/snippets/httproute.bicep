import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environment
  }
}

//HTTPROUTE
resource httproute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'httproute'
  location: 'global'
  properties: {
    application: app.id
  }
}
//HTTPROUTE

//FRONTEND
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: 'global'
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
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  location: 'global'
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
