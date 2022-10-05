import radius as radius

param environmentId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      volumes: {
        tempdir: {
          kind: 'ephemeral'
          mountPath: '/tmpfs'
          managedStore: 'memory'
        }
      }
    }
  }
}
//CONTAINER
