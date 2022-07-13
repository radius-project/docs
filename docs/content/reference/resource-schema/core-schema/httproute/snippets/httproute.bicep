import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

//HTTPROUTE
resource httproute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'httproute'
  location: location
  properties: {
    application: app.id
  }
}
//HTTPROUTE

//FRONTEND
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
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
  location: location
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
