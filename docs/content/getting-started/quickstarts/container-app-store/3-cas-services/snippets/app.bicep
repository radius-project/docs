import radius as radius

param location string = resourceGroup().location
param environment string

//PARAMS
param go_service_build object
param node_service_build object
param python_service_build object
//PARAMS
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'store'
  location: location
  properties: {
    environment: environment
  }
}

//GOAPP
resource go_app 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'go-app'
  location: location
  properties: {
    application: app.id
    container: {
      image: go_service_build.image
      ports: {
        web: {
          containerPort: 8050
        }
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'go-app'
        appPort: 8050
        provides: go_app_route.id
      }
    ]
  }
}
//GOAPP
//ROUTE
resource node_app_gateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'node-app-gateway'
  location: location
  properties: {
    application: app.id
    routes: [
      {
        path: '/'
        destination: node_app_route.id
      }
    ]
  }
}
resource node_app_route 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'node-app-route'
  location: location
  properties: {
    application: app.id
  }
}
//ROUTE
//DAPR
resource python_app_route 'Applications.Connector/daprInvokeHttpRoutes@2022-03-15-privatepreview' = {
  name: 'python-app'
  location: location
  properties: {
    environment: environment
    application: app.id
    appId: 'python-app'
  }
}
resource go_app_route 'Applications.Connector/daprInvokeHttpRoutes@2022-03-15-privatepreview' = {
  name: 'go-app'
  location: location
  properties: {
    environment: environment
    application: app.id
    appId: 'go-app'
  }
}
//DAPR
//NODEAPP
resource node_app 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'node-app'
  location: location
  properties: {
    application: app.id
    container: {
      image: node_service_build.image
      env: {
        'ORDER_SERVICE_NAME': python_app_route.properties.appId
        'INVENTORY_SERVICE_NAME': go_app_route.properties.appId
      }
      ports: {
        web: {
          containerPort: 3000
          provides: node_app_route.id
        }
      }
    }
    connections: {
      inventory: {
        source: go_app_route.id
      }
      orders: {
        source: python_app_route.id
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'node-app'
      }
    ]
  }
}
//NODEAPP
//PYTHONAPP
resource python_app 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'python-app'
  location: location
  properties: {
    application: app.id
    container: {
      image: python_service_build.image
      ports: {
        web: {
          containerPort: 5000
        }
      }
    }
    connections: {
      kind: {
        source: statestore.id
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'python-app'
        appPort: 5000
        provides: python_app_route.id
      }
    ]
  }
}
//PYTHONAPP
//STATESTORE
resource statestore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' existing = {
  name: 'orders'
}
//STATESTORE
