import radius as radius

param environment string

//ENV
resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'myenv'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'my-ns'
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'myapp.team.name':'Operations'
          'myapp.team.contact':'support-operations'
        }
      }
    ]
  }
}
//ENV

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'webapp'
  location: 'global'
  properties: {
    environment: environment
}
}

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend-ui'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'myapp.team.name':'UI'
          'myapp.team.contact':'support-UI'
        }
      }
    ]
}
}
//CONTAINER
