//ENVIRONMENT
extension radius

@description('The Azure region to deploy Azure resource(s) into. Defaults to the region of the target Azure resource group.')
param azLocation string = resourceGroup().location

@description('Specifies the environment for resources.')
param oidcIssuer string

resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'kv-volume-quickstart'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'kv-volume-quickstart'
      resourceId: 'self'
      identity: {
        kind: 'azure.com.workload'
        oidcIssuer: oidcIssuer
      }
    }
    providers: {
      azure: {
        scope: resourceGroup().id
      }
    }
  }
}
//ENVIRONMENT

//APP
resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: env.id
  }
}

resource volume 'Applications.Core/volumes@2023-10-01-preview' = {
  name: 'myvolume'
  properties: {
    application: app.id
    kind: 'azure.com.keyvault'
    resource: keyvault.id
    secrets: {
      mysecret: {
        name: 'mysecret'
      }
    }
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: 'kvqs-${uniqueString(resourceGroup().id)}'
  location: azLocation
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
  }

  resource mySecret 'secrets' = {
    name: 'mysecret'
    properties: {
      value: 'supersecret'
    }
  }
}
//APP

//CONTAINER
resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'mycontainer'
  properties: {
    application: app.id
    container: {
      image: 'debian'
      command: ['/bin/sh']
      args: ['-c', 'while true; do echo secret context : `cat /var/secrets/mysecret`; sleep 10; done']
      volumes: {
        volkv: {
          kind: 'persistent'
          source: volume.id
          mountPath: '/var/secrets'
        }
      }

    }
  }
}
//CONTAINER
