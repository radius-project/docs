extension radius

@description('The Azure region to deploy Azure resource(s) into. Defaults to the region of the target Azure resource group.')
param azLocation string = resourceGroup().location

param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'myvault'
  location: azLocation
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    softDeleteRetentionInDays: 7
  }
}

//VOLUME
resource volume 'Applications.Core/volumes@2023-10-01-preview' = {
  name: 'myvolume'
  properties: {
    application: app.id
    kind: 'azure.com.keyvault'
    resource: keyvault.id
    secrets: {
      mysecret: {
        name: 'secret1'      // required
        version: '1'         // optional, defaults to latest version
        alias: 'secretalias' // optional, defaults to secret name (mysecret)
        encoding: 'utf-8'    // optional, defaults to utf-8
      }
    }
    certificates: {
      mycertificate: {
        name: 'cert1'              // required
        version: '1'               // optional, defaults to latest version
        alias: 'certificatealias'  // optional, defaults to certificate name (mycertificate)
        encoding: 'base64'         // optional, defaults to utf-8, only available when value is privatekey
        certType: 'privatekey'     // required
        format: 'pem'              // optional, defaults to pfx
      }
    }
    keys: {
      mykey: {
        name: 'key1'       // required
        version: '1'       // optional, defaults to latest version
        alias: 'keyalias'  // optional, defaults to key name (mycertificate)
      }
    }
  }
}
//VOLUME
