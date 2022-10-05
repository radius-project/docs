import radius as radius

param location string = resourceGroup().location
param environmentId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-quickstart'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/quickstarts/dapr-backend:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    connections: {
      orders: {
        source: stateStore.id
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        provides: backendRoute.id
        appId: 'backend'
        appPort: 3000
      }
    ]
  }
}

resource backendRoute 'Applications.Connector/daprInvokeHttpRoutes@2022-03-15-privatepreview' = {
  name: 'backend-route'
  location: 'global'
  properties: {
    environment: environmentId
    application: app.id
    appId: 'backend'
  }
}

resource account 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'dapr${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }

  resource tableServices 'tableServices' = {
    name: 'default'

    resource table 'tables' = {
      name: 'dapr'
    }
  }
}

resource stateStore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'orders'
  location: 'global'
  properties: {
    environment: environmentId
    application: app.id
    kind: 'generic'
    type: 'state.azure.tablestorage'
    version: 'v1'
    metadata: {
      accountName: account.name
      accountKey: account.listKeys().keys[0].value
      tableName: split(account::tableServices::table.name,'/')[2] 
    }
  }
}
