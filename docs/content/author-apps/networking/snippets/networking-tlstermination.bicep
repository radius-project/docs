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
      // Specify TLS Termination for your app. Mutually exclusive with SSL Passthrough.
      // Hostname for TLS termination
      hostname: 'www.radapp.dev'
      // The Radius Secret Store holding TLS certificate data
      certificateFrom: wwwRadiusTLS.id
      // The minimum TLS protocol version to support. Defaults to 1.2
      minimumProtocolVersion: '1.2'
    }
    routes: [
      {
        destination: httpRoute.id
      }
    ]
  }
}

// secretstore resource to reference the TLS certficate and key.
resource wwwRadiusTLS 'Applications.Core/secretStores@2022-03-15-privatepreview' = {
  name: 'tls-wwwradius'
  properties: {
    application: app.id
    data: {
      'tls.crt': {}
      'tls.key': {}
    }
    // 'wwwradiustls' is the kubernetes tls secret in 'default' namespace
    resource: 'default/wwwradiustls'
  }
}
//GATEWAY
