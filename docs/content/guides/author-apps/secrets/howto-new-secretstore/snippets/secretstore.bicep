extension radius

@description('The app ID of your Radius Application. Set automatically by the rad CLI.')
param application string

//SECRET_STORE_NEW
@description('The data for your TLS certificate')
@secure()
param tlscrt string

@description('The key for your TLS certificate')
@secure()
param tlskey string

resource appCert 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'appcert'
  properties:{
    application: application
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
