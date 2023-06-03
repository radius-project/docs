import radius as radius

@description('ID of your Radius environment. Passed in automatically by rad CLI')
param environment string

@description('TLS certificate data')
@secure()
param tlscrt string

@description('TLS certificate key')
@secure()
param tlskey string

resource httpsApplication 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'https-application'
  properties: {
    environment: environment
  }
}

resource httpsSecretStore 'Applications.Core/secretStores@2022-03-15-privatepreview' = {
  name: 'https-secretstore'
  properties: {
    application: httpsApplication.id
    type: 'certificate'
    data: {
      'tls.crt': {
        encoding: 'base64'
        value: tlscrt
      }
      'tls.key': {
        encoding: 'base64'
        value: tlskey
      }
    }
  }
}

resource httpsGateway 'Applications.Core/gateways@2022-03-15-privatepreview' = {
  name: 'https-gateway'
  properties: {
    application: httpsApplication.id
    hostname: {
      fullyQualifiedHostname: 'YOUR_DOMAIN' // Replace with your domain name.
    }
    routes: [
      {
        path: '/'
        destination: httpsRoute.id
      }
    ]
    tls: {
      certificateFrom: httpsSecretStore.id
      minimumProtocolVersion: '1.2'
    }
  }
}

resource httpsRoute 'Applications.Core/httpRoutes@2022-03-15-privatepreview' = {
  name: 'https-route'
  properties: {
    application: httpsApplication.id
  }
}

resource httpsContainer 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'https-container'
  properties: {
    application: httpsApplication.id
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
      ports: {
        web: {
          containerPort: 3000
          provides: httpsRoute.id
        }
      }
    }
  }
}
