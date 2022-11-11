import radius as rad

@description('Specifies the environment for resources.')
#disable-next-line no-hardcoded-env-urls
param oidcIssuer string

@description('Specifies the location for resources.')
param location string = resourceGroup().location

@description('Specifies the scope of azure resources.')
param rootScope string = resourceGroup().id

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
        scope: rootScope
      }
    }
  }
}



