import radius as radius

param location string = resourceGroup().location
param environment string

param fileshareId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

//SAMPLE
resource myshare 'Applications.Core/volumes@2022-03-15-privatepreview' = {
  name: 'myshare'
  location: location
  properties: {
    application: app.id
    kind: 'azure.com.fileshare'
    resource: fileshareId
  }
}

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
      volumes: {
        myPersistentVolume: {
          kind: 'persistent'
          mountPath: '/tmpfs2'
          source: myshare.id
          rbac: 'read'
        }
      }
    }
  }
}
//SAMPLE
