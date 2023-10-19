import radius as rad

@description('The application ID of the Radius environment. Automatically set by the rad CLI.')
param application string

resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: application
    container: {
      image: 'radius.ghcr.io/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}

resource backend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'backend'
  properties: {
    application: application
    container: {
      image: 'nginx:latest'
      ports: {
        web: {
          containerPort: 80
        }
      }
    }
  }
}
