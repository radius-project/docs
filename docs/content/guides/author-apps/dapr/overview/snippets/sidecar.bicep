import radius as radius

param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//CONTAINER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'mycontainer'
  properties: {
    application: app.id
    container: {
      image: 'myimage'
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'mycontainer'
        appPort: 3500
      }
    ]
  }
}
//CONTAINER
