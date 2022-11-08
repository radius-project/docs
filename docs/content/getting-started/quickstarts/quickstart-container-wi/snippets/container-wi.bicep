import radius as radius

@description('Specifies the location for Radius resources.')
param location string = 'global'

@description('Specifies the location for Azure resources.')
param azLocation string = 'westus3'

@description('Specifies the port of the container resource.')
param port int = 3000

@description('Specifies the OIDC issuer URL')
#disable-next-line no-hardcoded-env-urls
param oidcIssuer string 

@description('Specifies the value of tenantId.')
param keyvaultTenantID string = subscription().tenantId

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'someotherenv'
  location: location
  properties: {
    compute: {
      kind: 'kubernetes'
      resourceId: 'self'
      namespace: 'someotherenv'
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
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: location
  properties: {
    environment: env.id
  }
}

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'ghcr.io/azure/azure-workload-identity/msal-go:latest'
      env: {
        KEYVAULT_NAME: keyvault.name
        KEYVAULT_URL: keyvault.properties.vaultUri
        SECRET_NAME: 'mysecret'
      }
      ports: {
        web: {
          containerPort: port
        }
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
  name: 'vqs-${uniqueString(resourceGroup().id)}'
  location: azLocation
  properties: {
    enabledForTemplateDeployment: true
    tenantId: keyvaultTenantID
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

