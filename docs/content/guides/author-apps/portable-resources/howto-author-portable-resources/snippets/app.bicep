import radius as radius

@description('Specifies the application for resources.')
param application string

//CONTAINER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
    }
  }
}
//CONTAINER
