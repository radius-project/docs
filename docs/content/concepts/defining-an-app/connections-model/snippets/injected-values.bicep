import radius as radius

param location string = resourceGroup().location
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

//SAMPLE
resource fe 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    //CONTAINER
    container: {
      image: 'radius.azurecr.io/frontend:latest'
    }
    //CONTAINER
    connections: {
      orders:{
        kind: 'Http'
        source: orderRoute.id
      }
    }
  }
}

resource orderRoute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'orders'
  location: location
  properties: {
    application: app.id
  }
}
//SAMPLE
