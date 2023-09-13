import radius as radius

@description('Specifies the location for resources.')
param location string = 'global'

@description('Specifies the image of the container resource.')
param magpieimage string = 'ghcr.io/radius-project/dev/magpiego:pr-498da3203f'

@description('Specifies the port of the container resource.')
param port int = 3000

@description('Specifies the environment for resources.')
param environment string

@description('Specifies the namespace for resources.')
param namespace string

//APPLICATION
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'manifest-default'
  location: location
  properties: {
    environment: environment
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

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  // Name must match with `ServiceAccount`, `Deployment`, and `Service` objects
  name: 'your-manifest-default-name'
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
