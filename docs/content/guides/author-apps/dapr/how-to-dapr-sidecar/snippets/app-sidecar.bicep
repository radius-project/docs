import radius as radius

@description('The ID of your Radius Application. Automatically injected by the rad CLI.')
param application string

// The backend container that runs the Dapr sidecar
resource backend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'backend'
  properties: {
    application: application
    container: {
      // This image is where the app's backend code lives
      image: 'ghcr.io/radius-project/samples/dapr-backend:latest'
      ports: {
        orders: {
          containerPort: 3000
        }
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
