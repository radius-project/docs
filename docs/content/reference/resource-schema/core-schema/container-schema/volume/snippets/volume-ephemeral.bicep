import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
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
