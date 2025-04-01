// Import the set of Radius resources (Applications.*) into Bicep
extension radius

@description('The Radius environment name to deploy the application and resources to.')
param environment string = 'default'

resource env 'Applications.Core/environments@2023-10-01-preview' existing = {
  name: environment
}

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'app'
  properties: {
    environment: env.id
  }
}

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: app.id
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}
