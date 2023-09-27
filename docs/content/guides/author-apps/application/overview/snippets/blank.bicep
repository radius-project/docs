import radius as radius

@description('The environment ID of your Radius application. Set automatically by the rad CLI.')
param environment string

resource myapp 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'my-application'
  properties: {
    environment: environment
  }
}
