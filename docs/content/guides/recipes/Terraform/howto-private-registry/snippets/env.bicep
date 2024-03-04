//SECRETSTORE
import radius as radius

@secure()
param pat string=''

resource secretStoreGit 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'my-git-secret-store'
  properties: {
    type: 'generic'
    data: {
      // Required value, refers to the personal access token or password of the git platform
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
  location: 'global'
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
    recipes: {
      'Applications.Core/extenders': {
        default: {
          templateKind: 'terraform'
          // Git template path
          templatePath:'git::my-git-url'
        }
      }
    }
  }
}
//ENV

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'my-app'
  location: 'global'
  properties: {
    environment: env.id
    extensions: [
      {
        kind: 'kubernetesNamespace'
        namespace: 'my-namespace'
      }
    ]
  }
}

resource webapp 'Applications.Core/extenders@2023-10-01-preview' = {
  name: 'my-redis-cache'
  properties: {
    application: app.id
    environment: env.id
    recipe: {
      name: 'default'
      parameters: {
        redis_cache_name: 'my-redis'
      }
    }
  }
}
