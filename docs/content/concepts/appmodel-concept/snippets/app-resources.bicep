import radius as radius

param radEnvironment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'my-app'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'my-backend'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'myimage'
    }
  }
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: 'mystorage/default/mycontainer'
}
