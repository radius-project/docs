import radius as radius

@description('Specifies the location for resources.')
param location string = 'global'

@description('Specifies the environment for resources.')
param environment string

@description('Specifies tls cert secret values.')
@secure()
param tlscrt string
@secure()
param tlskey string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'corerp-resources-secretstore'
  location: location
  properties: {
    environment: environment
    extensions: [
      {
          kind: 'kubernetesNamespace'
          namespace: 'corerp-resources-secretstore-app'
      }
    ]
  }
}

//SECRETSTORENEW
resource appCert 'Applications.Core/secretStores@2022-03-15-privatepreview' = {
  name: 'appcert'
  properties:{
    application: app.id
    type: 'certificate'
    data: {
      'tls.key': {
        value: tlskey
      }
      'tls.crt': {
        value: tlscrt
      }
    }
  }
}

//SECRETSTOREREF
resource existingAppCert 'Applications.Core/secretStores@2022-03-15-privatepreview' = {
  name: 'existing-appcert'
  properties:{
    application: app.id
    type: 'certificate'
    data: {
      'tls.crt': {
        valueFrom: {
          name: 'tls.crt'
        }
      }
      'tls.key': {
        valueFrom: {
          name: 'tls.key'
        }
      }
    }
    resource: 'secret-app-existing-secret'
  }
}
