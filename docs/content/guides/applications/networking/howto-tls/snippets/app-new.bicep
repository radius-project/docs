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
@description('TLS certificate data')
@secure()
param tlscrt string

@description('TLS certificate key')
@secure()
param tlskey string

resource secretstore 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'secretstore'
  properties: {
    application: application
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
