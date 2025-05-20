extension radius

resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'aci-demo'
  properties: {
    compute: {
      kind: 'aci'
      // Replace value with your resource group ID
      resourceGroup: '/subscriptions/<>/resourceGroups/<>'
      identity: {
        kind:'userAssigned'
        // Replace value with your managed identity resource ID
        managedIdentity: ['/subscriptions/<>/resourceGroups/<>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<>']
      }
    }
    recipes: {
      'Applications.Datastores/redisCaches': {
        default: {
          templateKind: 'bicep'
          plainHttp: true
          templatePath: 'ghcr.io/radius-project/recipes/azure/rediscaches:latest'
        }
      }
    }
    providers: {
      azure: {
        // Replace value with your resource group ID
        scope: '/subscriptions/<>/resourceGroups/<>'
      }
    }
  }
}
