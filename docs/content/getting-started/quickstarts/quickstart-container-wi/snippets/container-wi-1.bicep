import radius as radius

@description('Specifies the location for Radius resources.')
param location string = 'global'

@description('Specifies the location for Azure resources.')
param azLocation string = 'westus3'

@description('Specifies the OIDC issuer URL')
#disable-next-line no-hardcoded-env-urls
param oidcIssuer string 

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'iam-quickstart'
  location: location
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
