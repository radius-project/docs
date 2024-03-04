//SECRETSTORE
import radius as radius

resource secretStoreGithub 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'github'
  properties:{
    type: 'generic'
    data: {
      // Required key value
      pat: {
        value: '<my-access-token>'
      }
      // Optional key value
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
      resourceId: 'self'
      namespace: 'default'
    }
    recipeConfig: {
      terraform: {
        authentication:{
          git:{  
            // PAT is a required key value, personal access token
            pat:{
              // secretStore ID
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
