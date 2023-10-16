import radius as radius

@description('The app ID of your Radius Application. Set automatically by the rad CLI.')
param application string

//SECRET_STORE_REF
resource existingAppSecret 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'existing-appSecret'
  properties:{
    application: application
    resource: 'default/db-user-pass' // Reference to the name of an external Kubernetes secret store
    type: 'generic' // The type of secret in your resource
    data: {
      // The keys in this object are the names of the secrets in an external secret store
      username: {}
      password: {}
    }
  }
}
//SECRET_STORE_REF
