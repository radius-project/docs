import radius as rad

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' existing = {
  name: 'myapp'
}

// Backend is being invoked through service invocation
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'backend:latest'
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'backend'
        provides: daprRoute.id
      }
    ]
  }
}

resource daprRoute 'Applications.Link/daprInvokeHttpRoutes@2022-03-15-privatepreview' = {
  name: 'backend-invoke-route'
  location: 'global'
  properties: {
    environment: environment
    application: app.id
    appId: 'backend'
  }
}

// Frontend invokes backend
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'frontend:latest'
    }
    connections: {
      // Automatically inject environment variables
      backend: {
        source: daprRoute.id
      }
    }
  }
}
