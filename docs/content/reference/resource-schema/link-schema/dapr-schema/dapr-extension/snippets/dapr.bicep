import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
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
