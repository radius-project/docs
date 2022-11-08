import radius as rad

param environment string

resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: 'myvault'
}

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environment
  }
}

//EXAMPLE
//VOLUME
resource volume 'Applications.Core/volumes@2022-03-15-privatepreview' = {
  name: 'myvolume'
  location: 'global'
  properties: {
    application: app.id
    kind: 'azure.com.keyvault'
    resource: keyvault.id
    certificates: {
      mysecret: {
        name: 'mysecret'
      }
    }
  }
}
//VOLUME

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'myregistry/myimage:tag'
      volumes: {
        persistent: {
          kind: 'persistent'        // required
          source: volume.id         // required
          mountPath: '/var/secrets' // required
          rbac: 'read'              // optional, defaults to read
        }
      }
    }
  }
}
//EXAMPLE
