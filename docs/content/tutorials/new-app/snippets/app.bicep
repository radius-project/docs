// Import the set of Radius resources (Applications.*) into Bicep
import radius as radius

@description('The environment ID of your Radius application. Set automatically by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}
