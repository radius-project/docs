//ENVIRONMENT
import radius as radius

@description('The geo-location where the resource lives.')
param azLocation string = resourceGroup().location

@description('Specifies the OIDC issuer URL')
param oidcIssuer string 

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'iam-quickstart'
  properties: {
    compute: {
      kind: 'kubernetes'
      resourceId: 'self'
      namespace: 'iam-quickstart'
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

//CONTAINER
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: env.id
  }
}

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  properties: {
    application: app.id
    container: {
      image: 'ghcr.io/azure/azure-workload-identity/msal-go:latest'
      env: {
        KEYVAULT_NAME: keyvault.name
        KEYVAULT_URL: keyvault.properties.vaultUri
        SECRET_NAME: 'mysecret'
      }
    }
    connections: {
      vault: {
        source: keyvault.id
        iam: {
          kind: 'azure'
          roles: [
            'Key Vault Secrets User'
          ]
        }
      }
    }
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: 'qs-${uniqueString(resourceGroup().id)}'
  location: azLocation
  properties: {
    enabledForTemplateDeployment: true
    tenantId: subscription().tenantId
    enableRbacAuthorization:true
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
  resource mySecret 'secrets' = {
    name: 'mysecret'
    properties: {
      value: 'supersecret'
    }
  }
}
//CONTAINER
