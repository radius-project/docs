import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'myregistry/mycontainer:latest'
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'team.name':'frontend-eng'
        }
        annotations:{
          'app.io/port':'8081'
        }
      }
    ]
  }
}
//CONTAINER
