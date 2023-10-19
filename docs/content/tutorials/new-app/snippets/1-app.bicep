// Import the set of Radius resources (Applications.*) into Bicep
import radius as radius

@description('The ID of your Radius Application. Set automatically by the rad CLI.')
param application string

resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}
