import radius as radius

@description('The app ID of your Radius Application. Set automatically by the rad CLI.')
param application string

//CONTAINER
@description('Loads the Kubernetes base manifest file and turns content into a string.')
var manifest = loadTextContent('./manifest.yaml')

resource container 'Applications.Core/containers@2023-10-01-preview' = {
  // Name must match with `ServiceAccount`, `Deployment`, and `Service` objects
  name: 'my-microservice'
  properties: {
    application: application
    container: {
      // Points to your container image
      image: 'ghcr.io/radius-project/samples/demo:latest'
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
