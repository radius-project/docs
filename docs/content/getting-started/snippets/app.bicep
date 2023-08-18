// Import the set of Radius resources (Applications.*) into Bicep
import radius as radius

@description('The app ID of your Radius application. Set automatically by the rad CLI.')
param application string

resource demo 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'demo'
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
