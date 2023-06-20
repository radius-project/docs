import radius as rad


resource app 'Applications.Core/applications@2022-03-15-privatepreview' existing = {
  name: 'myapp'
}

// Backend is being invoked through service invocation
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  properties: {
    application: app.id
    container: {
      image: 'backend:latest'
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'backend'
      }
    ]
  }
}


// Frontend invokes backend
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'frontend:latest'
      env: {
        // Configures the appID of the backend service.
        CONNECTION_BACKEND_APPID: 'backend'
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'frontend'
      }
    ]
  }
}
