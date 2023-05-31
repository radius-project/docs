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
    type: 'certificate'
    // 'tls-wwwradius' resource references 'wwwradiustls' kubernetes tls secret in 'default' namespace
    resource: 'default/wwwradiustls'

    // data property requires 'tls.crt' and 'tls.key' secret key because Applications.Core/gateways needs these keys to enable TLS termination.
    data: {
      // Radius ensures that the specified 'tls.crt' and 'tls.key' keys are present in referenced Kubernetes secret,
      // 'default/wwwradiustls'. It will return the bad request error if the keys are not present in 'default/wwwradiustls'.
      'tls.crt': {}
      'tls.key': {}
    }
  }
}
//GATEWAY
