import radius as radius

param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource httpRoute 'Applications.Core/httpRoutes@2023-10-01-preview' = {
  name: 'http-route'
  properties: {
    application: app.id
  }
}

//GATEWAY
resource internetGateway 'Applications.Core/gateways@2023-10-01-preview' = {
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
