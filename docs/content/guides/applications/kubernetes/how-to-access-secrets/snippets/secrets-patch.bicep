extension radius

@description('Specifies the environment for resources.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    environment: environment
  }
}

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: app.id
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    runtimes: {
      kubernetes: {
        pod: {
          volumes: [ {
              name: 'secrets-vol'
              secret: {
                secretName: 'my-secret'
              }
            }
          ]
          containers: [
            {
              name: 'demo'
              volumeMounts: [ {
                  name: 'secrets-vol'
                  readOnly: true
                  mountPath: '/etc/secrets-vol'
                }
              ]
              env: [
                {
                  name: 'MY_SECRET'
                  valueFrom: {
                    secretKeyRef: {
                      name: 'my-secret'
                      key: 'secret-key'
                    }
                  }
                }
              ]
            }
          ]
          hostNetwork: true
        }
      }
    }
  }
}
