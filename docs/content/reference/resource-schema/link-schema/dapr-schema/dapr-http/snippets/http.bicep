import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//BACKEND
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'backend'
        appPort: 80
        provides: backendDapr.id
      }
    ]
  }
}
//BACKEND

//ROUTE
resource backendDapr 'Applications.Link/daprInvokeHttpRoutes@2022-03-15-privatepreview' = {
  name: 'dapr-backend'
  properties: {
    environment: environment
    application: app.id
    appId: 'backend'
  }
}
//ROUTE

//FRONTEND
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      env: {
        BACKEND_ID: backendDapr.properties.appId
      }
    }
    connections: {
      orders: {
        source: backendDapr.id
      }
    }
  }
}
//FRONTEND
