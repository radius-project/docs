//SECRETSTORE
import radius as radius

@description('username for postgres db')
@secure()
param username string

@description('password for postgres db')
@secure()
param password string

resource pgsSecretStore 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'my-secret-store'
  properties: {
    resource: 'my-secret-namespace/my-secret-store'
    type: 'generic'
    data: {
      username: {
        value: username
      }
      password: {
        value: password
      }
      host: {
        value: 'my-postgres-host'
      }
    }
  }
}
//SECRETSTORE

//ENV
resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'my-env'
  properties: {
    compute: {
      kind: 'kubernetes'
      resourceId: 'self'
      namespace: 'my-namespace'
    }
    recipeConfig: {
      terraform: {
        providers: {
          postgresql: [ {
              sslmode: 'disable'
              secrets: {
                username: {
                  source: pgsSecretStore.id
                  key: username
                }
                password: {
                  source: pgsSecretStore.id
                  key: password
                }
              }
            } ]
        }
      }
      env: {
        PGPORT: '5432'
      }
      envSecrets: {
        PGHOST: {
          source: pgsSecretStore.id
          key: 'host'
        }
      }
    }
    recipes: {
      'Applications.Core/extenders': {
        defaultpostgres: {
          templateKind: 'terraform'
          // Recipe template path
          templatePath: 'git::https://github.com/my-org/my-repo'
        }
      }
    }
  }
}
//ENV
