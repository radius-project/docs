import kubernetes as kubernetes {
  kubeConfig: ''
  namespace: 'default'
}
import radius as radius

param environment string

resource secret 'core/Secret@v1' = {
  metadata: {
    name: 'mysecret'
  }
  stringData: {
    key: 'value'
  }
}

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource container 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'mycontainer'
  properties: {
    application: app.id
    container: {
      image: 'nginx:latest'
      env: {
        SECRET: base64ToString(secret.data.key)
      }
    }
  }
}
