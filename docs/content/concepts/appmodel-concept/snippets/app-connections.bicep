import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'my-app'
  location: location
  properties: {
    environment: environment
  }
}

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'my-backend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'myimage'
    }
    connections: {
      mongo: {
        source: blobContainer.id
        iam: {
          kind: 'azure'
          roles: [
            'Storage Blob Data Reader'
          ]
        }
      }
    }
  }
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' existing = {
  name: 'mystorage/default/mycontainer'
}
