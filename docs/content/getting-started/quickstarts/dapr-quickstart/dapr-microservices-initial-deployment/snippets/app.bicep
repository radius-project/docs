import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-tutorial'
  location: location
  properties: {
    environment: environment
  }
}
