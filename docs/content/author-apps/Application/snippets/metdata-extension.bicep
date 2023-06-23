import radius as radius

param environment string

//APP
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'team.contact.name': 'Operations'
          'team.contact.alias': 'ops'
        }
        annotations: {
          'prometheus.io/port': '9090'
          'prometheus.io/scrape': 'true'
        }
      }
    ]
  }
}
//APP
