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
        spnTenantId: 'cd4b2887-304c-47e1-b4d5-65447fdd542b'
        appId: 'c7dd251f-811f-4ba2-a905-acd4d3f8f08b'
        spnCertificateFile: '/home/certs/filename.pfx'
      }
      version: 'v1'

    }
  }
  //SAMPLE
}
