import radius as rad

@description('Specifies the environment for resources.')
#disable-next-line no-hardcoded-env-urls
param oidcIssuer string

//ENV
resource environment 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'myenv'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'   // What kind of container runtime to use
      namespace: 'default' // Where application resources are rendered
      identity: {
        kind: 'azure.com.workload'
        oidcIssuer: oidcIssuer
      }
    }
  }
}
//ENV
