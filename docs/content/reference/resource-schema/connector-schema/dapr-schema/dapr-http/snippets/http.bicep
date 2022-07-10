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

//BACKEND
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
    }
    traits: [
      {
        kind: 'dapr.io/Sidecar@v1alpha1'
        appId: 'backend'
        appPort: 80
        provides: backendDapr.id
      }
    ]
  }
}
//BACKEND

//ROUTE
resource backendDapr 'Applications.Connector/daprInvokeHttpRoutes@2022-03-15-privatepreview' = {
  name: 'dapr-backend'
  location: location
  properties: {
    application: app.id
    appId: 'backend'
  }
}
//ROUTE

//FRONTEND
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
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
        kind: 'dapr.io/InvokeHttp'
        source: backendDapr.id
      }
    }
  }
}
//FRONTEND
