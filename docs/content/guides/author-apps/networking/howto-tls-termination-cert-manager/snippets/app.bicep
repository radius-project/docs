import radius as radius

@description('ID of the Radius environment. Passed in automatically via the rad CLI')
param environment string

resource demoApplication 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'demo-application'
  properties: {
    environment: environment
  }
}

resource demoSecretStore 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'demo-secretstore'
  properties: {
    application: demoApplication.id
    type: 'certificate'
    
    // Reference the existing default/demo-secret Kubernetes secret
    // Created automatically by cert-manager
    resource: 'default/demo-secret'
    data: {
      // Make the tls.crt and tls.key secrets available to the application
      'tls.crt': {}
      'tls.key': {}
    }
  }
}

resource demoGateway 'Applications.Core/gateways@2023-10-01-preview' = {
  name: 'demo-gateway'
  properties: {
    application: demoApplication.id
    hostname: {
       fullyQualifiedHostname: 'YOUR_DOMAIN' // Replace with your domain name.
    }
    routes: [
      {
        path: '/'
        destination: 'http://${demoContainer.name}:3000'
      }
    ]
    tls: {
      certificateFrom: demoSecretStore.id
      minimumProtocolVersion: '1.2'
    }
  }
}

resource demoContainer 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo-container'
  properties: {
    application: demoApplication.id
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}
