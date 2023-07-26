//BACKEND
import radius as radius

@description('Specifies the environment for resources.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr'
  properties: {
    environment: environment
  }
}

// The backend container that is connected to the Dapr state store
resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  properties: {
    application: app.id
    container: {
      // This image is where the app's backend code lives
      image: 'radius.azurecr.io/quickstarts/dapr-backend:edge'
      ports: {
        orders: {
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
        appId: 'backend'
        appPort: 3000
      }
    ]
  }
}

// The Dapr state store that is connected to the backend container
resource stateStore 'Applications.Link/daprStateStores@2022-03-15-privatepreview' = {
  name: 'statestore'
  properties: {
    // Provision Redis Dapr state store automatically via the default Radius Recipe
    environment: environment
    application: app.id
  }
}
//BACKEND

//FRONTEND
// The frontend container that serves the application UI
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      // This image is where the app's frontend code lives
      image: 'radius.azurecr.io/quickstarts/dapr-frontend:edge'
      env: {
        // An environment variable to tell the frontend container where to find the backend
        CONNECTION_BACKEND_APPID: 'backend'
      }
      // The frontend container exposes port 8080, which is used to serve the UI
      ports: {
        ui: {
          containerPort: 8080
        }
      }
    }
    // The extension to configure Dapr on the container, which is used to invoke the backend
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'frontend'
      }
    ]
  }
}
//FRONTEND
