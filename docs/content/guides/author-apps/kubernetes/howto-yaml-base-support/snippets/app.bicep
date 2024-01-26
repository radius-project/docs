import radius as radius

@description('Specifies the environment for resources.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'base-yaml-app'
  properties: {
    environment: environment
    extensions: [
      {
          kind: 'kubernetesNamespace'
          namespace: 'base-yaml-app'
      }
    ]
  }
}

resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'base-yaml-app'
  properties: {
    application: app.id
    container: {
      image: 'ghcr.io/radius-project/magpiego:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    connections: {}
    runtimes: {
      kubernetes: {
        base: loadTextContent('./manifest.yaml')
      }
    }
  }
}
