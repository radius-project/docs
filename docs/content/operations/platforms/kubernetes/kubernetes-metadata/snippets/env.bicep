import radius as radius

//ENV
resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'myenv'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'my-ns'
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'key1': 'envValueA'
          'key2': 'envValueB'
        }
      }
    ]
  }
}
//ENV

//APP
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: env.id
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'key1': 'appValue1'
          'key2': 'appValue2'
          'key3': 'appValue3'
        }
        annotation: {
          'prometheus.io/port': '9090'
          'prometheus.io/scrape': 'true'
        }
      }
    ]
  }
}
//APP

//CONTAINER
resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: 'global'
  properties: {
    application: app.id
    container: {
      image: 'myregistry/mycontainer:latest'
    }
    extensions: [
      {
        kind: 'kubernetesMetadata'
        labels: {
          'key1': 'containerValueX'
          'key2': 'conatienrValueY'
        }
      }
    ]
  }
}
//CONTAINER
