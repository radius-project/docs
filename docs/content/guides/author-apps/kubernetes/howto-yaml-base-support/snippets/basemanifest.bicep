import radius as radius

@description('Specifies the location for resources.')
param location string = 'global'

@description('Specifies the image of the container resource.')
param magpieimage string = 'ghcr.io/radius-project/dev/magpiego:pr-498da3203f'

@description('Specifies the port of the container resource.')
param port int = 3000

@description('Specifies the environment for resources.')
param environment string

@description('Specifies the application for resources.')
param application string

@description('Specifies the namespace for resources.')
param namespace string = 'my-microservice'

//APPLICATION
resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: application
  location: location
  properties: {
    environment: environment
    application: application
    extensions: [
      {
          kind: 'kubernetesNamespace'
          namespace: namespace
      }
    ]
  }
}
//APPLICATION

//CONTAINER
@description('Loads the Kubernetes base manifest file and turns content into a string.')
var manifest = loadTextContent('./basemanifest.yaml')

resource container 'Applications.Core/containers@2023-10-01-preview' = {
  // Name must match with `ServiceAccount`, `Deployment`, and `Service` objects
  name: 'my-microservice'
  location: location
  properties: {
    application: app.id
    container: {
      // Points to your container image
      image: magpieimage
      ports: {
        web: {
          // Port must match with `Service` object port
          containerPort: port
        }
      }
    }
    connections: {}
    runtimes: {
      kubernetes: {
        base: manifest
      }
    }
  }
}
//CONTAINER
