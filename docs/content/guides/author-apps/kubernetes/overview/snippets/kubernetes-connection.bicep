extension kubernetes {
  kubeConfig: ''
  namespace: 'default'
}
extension radius

param environment string

resource secret 'core/Secret@v1' = {
  metadata: {
    name: 'mysecret'
  }
  stringData: {
    key: 'value'
  }
}

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'myapp'
  properties: {
    environment: environment
  }
}

resource container 'Applications.Core/containers@2023-10-01-preview' = {
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
