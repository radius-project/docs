//IMPORT
extension radius
//IMPORT

//PARAM
@description('The ID of your Radius Application. Set automatically by the rad CLI.')
param application string
//PARAM

//CONTAINER
resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
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
  }
}
//CONTAINER
