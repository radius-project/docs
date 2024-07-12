//SECRETSTORE
extension radius

@description('Required value, refers to the personal access token or password of the git platform')
@secure()
param pat string

resource secretStoreGit 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'my-git-secret-store'
  properties: {
    resource: 'my-secret-namespace/github'
    type: 'generic'
    data: {
      pat: {
        value: pat 
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
      namespace: 'my-namespace'
    }
    recipeConfig: {
      terraform: {
        authentication: {
          git: {
            pat: {
              // The hostname of your git platform, such as 'dev.azure.com' or 'github.com'
              'github.com':{
                secret: secretStoreGit.id
              }
            }
          }
        }
      }
    }
  }
}
//ENV
