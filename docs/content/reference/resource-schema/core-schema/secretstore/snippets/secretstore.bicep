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

//SECRET_STORE_NEW
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
//SECRET_STORE_NEW

//SECRET_STORE_REF
resource existingAppCert 'Applications.Core/secretStores@2022-03-15-privatepreview' = {
  name: 'existing-appcert'
  properties:{
    application: app.id
    resource: 'secret-app-existing-secret' // Reference to the name of a secret in existing secret store
    type: 'certificate' // The type of secret in your resource
    data: {
      'tls.crt': {}
      'tls.key': {}
    }
  }
}
//SECRET_STORE_REF
