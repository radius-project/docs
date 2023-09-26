import radius as radius

@description('ID of your Radius environment. Passed in automatically by rad CLI')
param environment string

resource httpsApplication 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'https-application'
  properties: {
    environment: environment
  }
}

resource httpsSecretStore 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'https-secretstore'
  properties: {
    application: httpsApplication.id
    type: 'certificate'
    // Reference the existing default/tls-certificate Kubernetes secret
    resource: 'default/tls-certificate'
    data: {
      // Make the tls.crt and tls.key secrets available to the application
      'tls.crt': {}
      'tls.key': {}
    }
  }
}

resource httpsGateway 'Applications.Core/gateways@2023-10-01-preview' = {
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

resource httpsRoute 'Applications.Core/httpRoutes@2023-10-01-preview' = {
  name: 'https-route'
  properties: {
    application: httpsApplication.id
  }
}

resource httpsContainer 'Applications.Core/containers@2023-10-01-preview' = {
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
