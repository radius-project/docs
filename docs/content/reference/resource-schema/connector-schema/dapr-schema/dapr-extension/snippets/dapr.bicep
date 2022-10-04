import radius as radius

param radEnvironment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

//SAMPLE
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: 'global'
  properties: {
    application: app.id
    //CONTAINER
    container: {
      image: 'registry/container:tag'
    }
    //CONTAINER
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'frontend'
        appPort: 3000
      }
    ]
  }
}
//SAMPLE
