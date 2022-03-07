resource app 'radius.dev/Application@v1alpha3' = {
  name: 'dapr-secretstore-generic'

  //SAMPLE
  resource secretstore 'dapr.io.SecretStore@v1alpha3' = {
    name: 'secretstore-generic'
    properties: {
      kind: 'generic'
      type: 'secretstores.azure.keyvault'
      metadata: {
        vaultName: 'test'
      }
      version: 'v1'

    }
  }
  //SAMPLE
}
