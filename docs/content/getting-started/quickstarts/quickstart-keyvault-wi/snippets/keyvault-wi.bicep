//ENVIRONMENT
import radius as rad

@description('Specifies the environment for resources.')
param oidcIssuer string

@description('Specifies the location for Radius resources.')
param location string = 'global'

@description('Specifies the location for Azure resources.')
param azLocation string = resourceGroup().location

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'kv-volume-quickstart'
  location: location
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
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: env.id
  }
}

resource volume 'Applications.Core/volumes@2022-03-15-privatepreview' = {
  name: 'myvolume'
  location: location
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
resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'debian'
      command: ['/bin/sh']
      args: ['-c', 'while true; do ls /var/secrets; sleep 10;done']
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


