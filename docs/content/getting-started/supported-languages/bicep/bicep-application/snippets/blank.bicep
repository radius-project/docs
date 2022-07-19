import radius as radius

param location string = resourceGroup().location
param environment string

resource myapp 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'my-application'
  location: location
  properties: {
    environment: environment
  }
}
