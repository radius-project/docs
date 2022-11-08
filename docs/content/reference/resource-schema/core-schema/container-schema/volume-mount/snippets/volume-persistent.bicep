import radius as rad

resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: 'myvault'
}

@description('Specifies the environment for resources.')
#disable-next-line no-hardcoded-env-urls
param oidcIssuer string

@description('Specifies the scope of azure resources.')
param rootScope string = resourceGroup().id

// myenv environment resource where workload identity is supported.

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'myenv'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'
      resourceId: 'self'
      namespace: 'default'
      identity: {
        kind: 'azure.com.workload'
        oidcIssuer: oidcIssuer
      }
    }
    providers: {
      azure: {
        scope: rootScope
      }
    }
  }
}


resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: env
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
