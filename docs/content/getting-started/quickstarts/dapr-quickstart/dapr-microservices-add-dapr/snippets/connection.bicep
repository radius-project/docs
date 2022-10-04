import radius as radius

param radEnvironment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-quickstart'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

//BACKEND
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  location: 'global'
  properties: {
    application: app.id
    //CONTAINER
    container: {
      image: 'radius.azurecr.io/quickstarts/dapr-backend:latest'
      ports: {
        orders: {
          containerPort: 3000
          provides: backendRoute.id
        }
      }
    }
    //CONTAINER
    connections: {
      orders: {
        source: stateStore.id
      }
    }
    //EXTENSIONS
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'backend'
        appPort: 3000
        provides: backendRoute.id
      }
    ]
    //EXTENSIONS
  }
}
//BACKEND

resource backendRoute 'Applications.Connector/daprInvokeHttpRoutes@2022-03-15-privatepreview' = {
  name: 'dapr-backend'
  location: 'global'
  properties: {
    environment: radEnvironment
    application: app.id
    appId: 'backend'
  }
}

resource stateStore 'Applications.Connector/daprStateStores@2022-03-15-privatepreview' = {
  name: 'orders'
  location: 'global'
  properties: {
    environment: radEnvironment
    application: app.id
    kind: 'generic'
    type: 'state.redis'
    version: 'v1'
    metadata: {
      redisHost: ''
      redisPassword: ''
    }
  }
}
