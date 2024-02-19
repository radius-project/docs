import radius as radius

@description('The ID of your Radius Application. Automatically injected by the rad CLI.')
param application string

@description('The ID of your Radius environment. Set automatically by the rad CLI.')
param environment string

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
      livenessProbe: {
        kind: 'httpGet'
        containerPort: 3000
        path: '/healthz'
        initialDelaySeconds: 10
      }
    }
    extensions: [
      {
        kind: 'daprSidecar'
        appId: 'demo'
        appPort: 3000
      }
    ]
  }
}
