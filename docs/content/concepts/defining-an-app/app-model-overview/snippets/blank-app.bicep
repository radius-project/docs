import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'example-app'
  location: location
  properties: {
    environment: environment
  }
}
