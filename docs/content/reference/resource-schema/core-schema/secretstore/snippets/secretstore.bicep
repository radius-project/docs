extension radius

@description('Specifies the location for resources.')
param location string = 'global'

@description('Specifies the environment for resources.')
param environment string

@description('Specifies tls cert secret values.')
@secure()
param tlscrt string
@secure()
param tlskey string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
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
resource appCert 'Applications.Core/secretStores@2023-10-01-preview' = {
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
resource existingAppCert 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'existing-appcert'
  properties:{
    application: app.id
    resource: 'secret-app-existing-secret' // Reference to the name of an external secret store
    type: 'certificate' // The type of secret in your resource
    data: {
      // The keys in this object are the names of the secrets in an external secret store
      'tls.crt': {}
      'tls.key': {}
    }
  }
}
//SECRET_STORE_REF
