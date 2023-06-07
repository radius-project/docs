import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-secretstore-generic'
  properties: {
    environment: environment
  }
}
//SAMPLE
resource secretstore 'Applications.Link/daprSecretStores@2022-03-15-privatepreview' = {
  name: 'secretstore-generic'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
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
