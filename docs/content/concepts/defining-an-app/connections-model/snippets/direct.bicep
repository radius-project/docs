import radius as radius

param location string = resourceGroup().location
param environment string
param storageId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'shopping-app'
  location: location
  properties: {
    environment: environment
  }
}

//SAMPLE
resource store 'Applications.Core/containers@2022-03-15-privatepreview' = {
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
    environment: environment
    application: app.id
    kind: 'state.azure.tablestorage'
    resource: storageId
  }
  //PROPERTIES
}
//SAMPLE
