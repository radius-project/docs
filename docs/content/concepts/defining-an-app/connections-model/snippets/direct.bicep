import radius as radius

param location string = resourceGroup().location
param environment string
param storage resource 'Microsoft.Storage/storageAccounts@2021-06-01'

resource app 'radius.dev/Application@v1alpha3' = {
  name: 'shopping-app'
  location: location
  properties: {
    environment: environment
  }
}

//SAMPLE
resource store 'Container' = {
  name: 'storefront'
  location: location
  properties: {
    application: app.id
    //CONTAINER
    container: {
      image: 'radius.azurecr.io/storefront'
    }
    //CONTAINER
    connections: {
      inventory: {
        kind: 'dapr.io/StateStore'
        source: inventory.id
      }
    }
  }
}

resource inventory 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'inventorystore'
  location: location
  //PROPERTIES
  properties: {
    application: app.id
    kind: 'state.azure.tablestorage'
    resource: storage.id
  }
  //PROPERTIES
}
//SAMPLE
