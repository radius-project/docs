import radius as radius

@description('The ID of your Radius environment. Set automatically by the rad CLI.')
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

    // Reference to an existing Kubernetes namespace and secret.
    // Here, it is the 'wwwradiustls' TLS secret in the 'default' namespace.
    resource: 'default/wwwradiustls'

    // The secrets to make available to other Radius resources via this secret store.
    // To enable TLS termination in Applications.Core/gateways, both 'tls.crt' and 'tls.key' secrets must exist
    // in the referenced secret store and also be listed here.
    data: {
      // Specify the secret keys to be made available, with no additional configuration.
      // These secrets must already exist in the referenced Kubernetes secret, 'default/wwwradiustls'.
      // If they do not exist, an error will be thrown.
      'tls.crt': {}
      'tls.key': {}
    }
  }
}
//GATEWAY
