import radius as radius

param environment string

param location string = resourceGroup().location

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    environment: environment
  }
}

resource todoFrontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/webapptutorial-todoapp'
      ports: {
        web: {
          containerPort: 3000
          provides: todoRoute.id
        }
      }
    }
  }
}

resource todoRoute 'Applications.Core/httproutes@2022-03-15-privatepreview' = {
  name: 'frontend-route'
  location: location
  properties: {
    application: app.id
  }
}

resource todoGateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'gateway'
  location: location
  properties: {
    application: app.id
    routes: [
      {
        path: '/'
        destination: todoRoute.id
      }
    ]
  }
}
