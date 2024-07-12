extension radius


resource app 'Applications.Core/applications@2023-10-01-preview' existing = {
  name: 'myapp'
}

// Backend is being invoked through service invocation
resource backend 'Applications.Core/containers@2023-10-01-preview' = {
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
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
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
