import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//CONTAINER
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
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
