import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'radius.dev/Application@v1alpha3' = {
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
        kind:'azure'
        source: storageAccount.id
        roles: [
          'Reader and Data Access'
          'Storage Blob Data Contributor'
        ]
      }
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'StorageAccount-${guid(resourceGroup().name)}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
