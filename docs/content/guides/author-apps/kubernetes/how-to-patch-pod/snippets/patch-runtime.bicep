import radius as radius

@description('The ID of your Radius Application. Automatically injected by the rad CLI.')
param application string

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    runtimes: {
      kubernetes: {
        pod: {
          containers: [
            {
              name: 'log-collector'
              image: 'ghcr.io/radius-project/fluent-bit:2.1.8'
            }
          ]
          hostNetwork: true
        }
      }
    }
  }
}
