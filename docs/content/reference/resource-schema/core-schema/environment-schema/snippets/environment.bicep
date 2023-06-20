import radius as rad

param oidcIssuer string

//ENV
resource environment 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'myenv'
  properties: {
    compute: {
      kind: 'kubernetes'   // Required. The kind of container runtime to use
      namespace: 'default' // Required. The Kubernetes namespace in which to render application resources
      identity: {          // Optional. External identity providers to use for connections
        kind: 'azure.com.workload'
        oidcIssuer: oidcIssuer
      }
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'team.contact.name': 'Frontend'
        }
      }
    ]
  }
}
//ENV
