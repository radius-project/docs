import radius as radius

@description('The ID of your Radius environment. Injected automatically by the rad CLI.')
param environment string

@description('The data for your TLS certificate')
@secure()
param tlscrt string

@description('The key for your TLS certificate')
@secure()
param tlskey string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'corerp-resources-secretstore'
  properties: {
    environment: environment
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
    resource: 'secret-app-existing-secret' // Reference to the name of an external Kubernetes secret store
    type: 'certificate' // The type of secret in your resource
    data: {
      // The keys in this object are the names of the secrets in an external secret store
      'tls.crt': {}
      'tls.key': {}
    }
  }
}
//SECRET_STORE_REF
