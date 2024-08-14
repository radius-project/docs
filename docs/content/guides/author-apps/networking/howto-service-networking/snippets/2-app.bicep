extension radius

@description('The application ID of the Radius environment. Automatically set by the rad CLI.')
param application string

//FRONTEND
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
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
    connections: {
      backend: {
        source: 'http://backend:80'
      }
    }
  }
}
//FRONTEND

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
