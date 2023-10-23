import radius as radius


@description('Specifies the image of the container resource.')
param magpieimage string = 'ghcr.io/radius-project/dev/magpiego:pr-498da3203f'

@description('Specifies the port of the container resource.')
param port int = 3000

@description('Specifies the environment for resources.')
param environment string

@description('Specifies the application for resources.')
param application string

//CONTAINER
@description('Loads the Kubernetes base manifest file and turns content into a string.')
var manifest = loadTextContent('./basemanifest.yaml')

resource container 'Applications.Core/containers@2023-10-01-preview' = {
  // Name must match with `ServiceAccount`, `Deployment`, and `Service` objects
  name: 'my-microservice'
  properties: {
    application: application
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
