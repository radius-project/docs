import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-secretstore-generic'
  location: 'global'
  properties: {
    environment: environment
  }
}
//SAMPLE
resource secretstore 'Applications.Link/daprSecretStores@2022-03-15-privatepreview' = {
  name: 'secretstore-generic'
  location: 'global'
  properties: {
    environment: environment
    application: app.id
    mode: 'values'
    kind: 'generic'
    type: 'secretstores.azure.keyvault'
    metadata: {
      vaultName: 'myvault'
      azureTenantId: '<GUID>'
      azureClientId: '<GUID>'
      azureClientSecret: '*****'
    }
    version: 'v1'
  }
}
//SAMPLE
