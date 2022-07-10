import kubernetes as kubernetes
import radius as radius

param location string = resourceGroup().location
param environment string

resource secret 'kubernetes.core/Secret@v1' = {
  metadata: {
    name: 'mysecret'
  }
  data: {
    key: 'value'
  }
}

resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'
  location: location
  properties: {
    environment: environment
  }
}

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'myimage'
      env: {
        SECRET: secret.data['key']
      }
    }
  }
}
