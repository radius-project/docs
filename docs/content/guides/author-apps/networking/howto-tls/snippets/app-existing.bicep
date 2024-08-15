//FRONTEND
extension radius

@description('The application ID being deployed. Injected automtically by the rad CLI')
param application string

resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}
//FRONTEND

//SECRETS
resource secretstore 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'secretstore'
  properties: {
    application: application
    type: 'certificate'
    // Reference the existing tls-certificate Kubernetes secret in the default namespace
    // Change this if your Kubernetes secret is in a different namespace or is named differently
    resource: 'default/tls-certificate'
    data: {
      // Make the tls.crt and tls.key secrets available to the application
      // Change these if your secrets are named differently
      'tls.crt': {}
      'tls.key': {}
    }
  }
}
//SECRETS

//GATEWAY
resource gateway 'Applications.Core/gateways@2023-10-01-preview' = {
  name: 'gateway'
  properties: {
    application: application
    hostname: {
      fullyQualifiedHostname: 'YOUR_DOMAIN' // Replace with your domain name.
    }
    tls: {
      certificateFrom: secretstore.id
      minimumProtocolVersion: '1.2'
    }
    routes: [
      {
        path: '/'
        destination: 'http://${frontend.name}:3000'
      }
    ]
  }
}
//GATEWAY
