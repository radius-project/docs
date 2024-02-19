// Import the set of Radius resources (Applications.*) into Bicep
import radius as radius

//KUBERNETES
@description('Specifies Kubernetes namespace for the user.')
param namespace string = 'default'

import kubernetes as kubernetes{
  kubeConfig: ''
  namespace: namespace
}
//KUBERNETES

@description('The app ID of your Radius Application. Set automatically by the rad CLI.')
param application string

//APPLICATION
resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
      env: {
        SECRET: base64ToString(secret.data.key)
      }
    }
  }
}

resource secret 'core/Secret@v1' = {
  metadata: {
    name: 'my-secret'
  }
  stringData: {
    key: 'my-secret-value'
  }
}
//APPLICATION
