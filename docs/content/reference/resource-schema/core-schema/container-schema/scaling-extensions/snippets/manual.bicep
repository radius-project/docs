import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//SAMPLE
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  properties: {
    application: app.id
    //CONTAINER
    container: {
      image: 'registry/container:tag'
    }
    //CONTAINER
    extensions: [
      {
        kind:  'manualScaling'
        replicas: 5
      }
    ]
  }
}
//SAMPLE
