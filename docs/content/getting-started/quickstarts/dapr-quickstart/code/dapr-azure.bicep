import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-tutorial'
  location: location
  properties: {
    environment: environment
  }
}

resource frontendGateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'gateway'
  location: location
  properties: {
    application: app.id
    routes: [
      {
        path: '/'
        destination: frontendRoute.id
      }
    ]
  }
}
  
resource frontendRoute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'frontend-route'
  location: location
  properties: {
    application: app.id
  }
}
  
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/daprtutorial-frontend'
      ports:{
        ui: {
          containerPort: 80
          provides: frontendRoute.id
        }
      }
    }
    connections: {
      backend: {
        kind: 'dapr.io/InvokeHttp'
        source: daprBackend.id
      }
    }
    traits: [
      {
        kind: 'dapr.io/Sidecar@v1alpha1'
        appId: 'frontend'
      }
    ]
  }
}

//BACKEND
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/daprtutorial-backend'
      ports: {
        orders: {
          containerPort: 3000
        }
      }
    }
    traits: [
      {
        kind: 'dapr.io/Sidecar@v1alpha1'
        appId: 'backend'
        appPort: 3000
        provides: daprBackend.id
      }
    ]
  }
}
//BACKEND

//ROUTE
resource daprBackend 'Applications.Connector/daprInvokeHttpRoutes@2022-03-15-privatepreview' = {
  name: 'dapr-backend'
  location: location
  properties: {
    environment: environment
    application: app.id
    appId: 'backend'
  }
}
//ROUTE

resource account 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'daprquickstart${uniqueString(resourceGroup().id)}'
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
  location: location
  properties: {
    environment: environment
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
