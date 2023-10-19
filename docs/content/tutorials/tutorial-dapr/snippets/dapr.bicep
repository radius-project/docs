//BACKEND
import radius as radius

@description('Specifies the environment for resources.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'dapr'
  properties: {
    environment: environment
  }
}

// The backend container that is connected to the Dapr state store
resource backend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'backend'
  properties: {
    application: app.id
    container: {
      // This image is where the app's backend code lives
      image: 'radius.ghcr.io/samples/dapr-backend:latest'
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
resource stateStore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
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
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      // This image is where the app's frontend code lives
      image: 'radius.ghcr.io/samples/dapr-frontend:latest'
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
