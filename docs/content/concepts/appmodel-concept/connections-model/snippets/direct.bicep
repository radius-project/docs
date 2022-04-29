param storage resource 'Microsoft.Storage/storageAccounts@2021-06-01'

resource app 'radius.dev/Application@v1alpha3' = {
  name: 'shopping-app'

  //SAMPLE
  resource store 'Container' = {
    name: 'storefront'
    properties: {
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

  resource inventory 'dapr.io.StateStore' = {
    name: 'inventorystore'
    //PROPERTIES
    properties: {
      kind: 'state.azure.tablestorage'
      resource: storage.id
    }
    //PROPERTIES
  }
  //SAMPLE

}
