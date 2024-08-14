extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
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
