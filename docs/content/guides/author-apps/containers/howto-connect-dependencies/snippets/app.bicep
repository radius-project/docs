import radius as rad

@description('The app ID of your Radius application. Set automatically by the rad CLI.')
param application string

resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'mycontainer'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/quickstarts/envvars:edge'
    }
  }
}
