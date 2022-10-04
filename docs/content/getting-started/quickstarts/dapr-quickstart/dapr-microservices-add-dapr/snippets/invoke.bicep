import radius as radius

param radEnvironment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-quickstart'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

//SAMPLE
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  location: 'global'
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

resource backendRoute 'Applications.Connector/daprInvokeHttpRoutes@2022-03-15-privatepreview' = {
  name: 'backend-route'
  location: 'global'
  properties: {
    environment: radEnvironment
    application: app.id
    appId: 'backend'
  }
}
//SAMPLE
