extension radius

param environment string

//APP
resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
    extensions: [
      {
        kind: 'kubernetesNamespace'
        namespace: 'myapp'
      }
      {
        kind: 'kubernetesMetadata'
        labels: {
          'team.contact.name': 'frontend'
        }
      }
    ]
  }
}
//APP
