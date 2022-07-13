import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'azure-storage-app'
  location: location
  properties: {
    environment: environment
  }
}

resource store 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'storage-service'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'registry/container:tag'
    }
    connections: {
      storageresource: {
        iam: {
          kind: 'azure'
          roles: [
            'Reader and Data Access'
            'Storage Blob Data Contributor'
          ]
        }
        source: storageAccount.id
      }
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'StorageAccount-${guid(resourceGroup().name)}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
