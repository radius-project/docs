import radius as radius

param environment string

//APP
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
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
          'team.contact.name':0 'frontend'
        }
      }
    ]
  }
}
//APP
