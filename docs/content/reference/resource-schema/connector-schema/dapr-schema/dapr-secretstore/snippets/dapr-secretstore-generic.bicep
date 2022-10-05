import radius as radius

param environmentId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'dapr-secretstore-generic'
  location: 'global'
  properties: {
    environment: environmentId
  }
}
//SAMPLE
resource secretstore 'Applications.Connector/daprSecretStores@2022-03-15-privatepreview' = {
  name: 'secretstore-generic'
  location: 'global'
  properties: {
    environment: environmentId
    application: app.id
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
