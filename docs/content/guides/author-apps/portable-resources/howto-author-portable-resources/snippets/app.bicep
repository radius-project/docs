import radius as radius

@description('Specifies the application for resources.')
param application string

//CONTAINER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
    }
  }
}
//CONTAINER
