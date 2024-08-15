extension radius

//ENV
resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'myenv'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'my-ns'
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'team.key1': 'envValue1'
          'team.key2': 'envValue2'
        }
      }
    ]
  }
}
//ENV

//APP
resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: env.id
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'team.key1': 'appValue1'
          'team.key2': 'appValue2'
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

//CONTAINER
resource frontend 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'myregistry/mycontainer:latest'
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'team.key2': 'containerValue2'
          'team.contact.name': 'Frontend'
          'team.contact.alias': 'frontend-eng'
        }
      }
    ]
  }
}
//CONTAINER
