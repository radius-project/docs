import radius as radius

param environmentId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-quickstart'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

//SAMPLE
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  location: 'global'
  properties: {
    application: app.id
    //CONTAINER
    container: {
      image: 'radius.azurecr.io/quickstarts/dapr-backend:latest'
      ports: {
        orders: {
          containerPort: 3000
        }
      }
    }
    //CONTAINER
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'backend'
        appPort: 3000
      }
    ]
  }
}
//SAMPLE
