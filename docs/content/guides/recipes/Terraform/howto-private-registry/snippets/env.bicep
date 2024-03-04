//SECRETSTORE
import radius as radius

resource secretStoreGithub 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'github'
  properties:{
    type: 'generic'
    data: {
      // Required value, refers to the personal access token or password of the git platform
      pat: {
        value: '<my-access-token>'
      }
      // Optional value, refers to the username of the git platform
      username: {
        value: '<my-username>'
      }
    }
  }
}
//SECRETSTORE

//ENV
resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'prod'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'default'
    }
    recipeConfig: {
      terraform: {
        authentication:{
          git:{  
            pat:{
              // The hostname of your git platform, such as 'dev.azure.com' or 'github.com'
              'dev.azure.com':{
                secret: secretStoreGithub.id
              }
            }
          }          
        }
      }
//ENV
    }


//RECIPE
    recipes: {      
      'Applications.Datastores/mongoDatabases':{
          default: {
            templateKind: 'terraform'
            // Git template path
            templatePath: 'git::https://dev.azure.com/test-private-repo'
          }
      }
    }
  //RECIPE
 }
}
