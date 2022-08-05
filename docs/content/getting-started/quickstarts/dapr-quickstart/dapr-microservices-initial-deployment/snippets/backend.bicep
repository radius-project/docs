import radius as radius

param location string = 'global'
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-quickstart'
  location: location
  properties: {
    environment: environment
  }
}

resource backend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'backend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/quickstarts/dapr-backend:edge'
      ports: {
        orders: {
          containerPort: 3000
        }
      }
    }
  }
}
