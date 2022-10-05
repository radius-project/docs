import radius as radius

param environmentId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'my-application'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend-service'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'nginx:latest'
    }
  }
}
