import radius as radius

@description('The ID of your Radius Application. Automatically injected by the rad CLI.')
param application string

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

//CONTAINER
resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'demo'
        appPort: 3000
      }
    ]
     connections: {
      redis: {
        source: stateStore.id
      }
    }
  }
}
//CONTAINER

//STATESTORE
resource stateStore 'Applications.Dapr/stateStores@2023-10-01-preview' = {
  name: 'statestore'
  properties: {
    environment: environment
    application: application
  }
}
//STATESTORE
