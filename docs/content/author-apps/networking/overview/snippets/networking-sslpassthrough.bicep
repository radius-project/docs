import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource httpRoute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'http-route'
  properties: {
    application: app.id
  }
}

//GATEWAY
resource internetGateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'internet-gateway'
  properties: {
    application: app.id
    tls: {
      sslPassthrough: true
    }
    routes: [
      {
        destination: httpRoute.id
      }
    ]
  }
}
//GATEWAY
