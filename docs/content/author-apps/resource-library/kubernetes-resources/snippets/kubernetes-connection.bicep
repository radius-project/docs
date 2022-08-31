import kubernetes as kubernetes {
  kubeConfig: '*****'
  namespace: 'default'
}
import radius as radius

param environment string

resource secret 'core/Secret@v1' = {
  metadata: {
    name: 'mysecret'
  }
  data: {
    key: 'value'
  }
}

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  location: 'global'
  properties: {
    environment: environment
  }
}

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  location: 'global'
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
