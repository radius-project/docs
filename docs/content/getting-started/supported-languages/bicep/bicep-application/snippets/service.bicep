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

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend-service'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'nginx:latest'
    }
  }
}
