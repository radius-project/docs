import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-quickstart'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/quickstarts/dapr-backend:latest'
      ports: {
        orders: {
          containerPort: 3000
          provides: backendRoute.id
        }
      }
    }
    //EXTENSIONS
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'backend'
        appPort: 3000
      }
    ]
    //EXTENSIONS
  }
}

resource backendRoute 'Applications.Link/daprInvokeHttpRoutes@2022-03-15-privatepreview' = {
  name: 'backend-route'
  properties: {
    environment: environment
    application: app.id
    appId: 'backend'
  }
}
//SAMPLE
