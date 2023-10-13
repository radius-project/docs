import radius as radius

@description('The app ID of your Radius Application. Set automatically by the rad CLI.')
param application string

//SECRET_STORE_REF
@description('The data for your TLS certificate')
@secure()
param tlscrt string

@description('The key for your TLS certificate')
@secure()
param tlskey string

resource existingAppCert 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'existing-appcert'
  properties:{
    application: application
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
