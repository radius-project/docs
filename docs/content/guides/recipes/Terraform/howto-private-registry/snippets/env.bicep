import radius as radius

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
              // This has to be a path name to the secret store
              'dev.azure.com':{
                secret: secretStoreGithub.id
              }
            }
          }          
        }
      }
    }
//ENV

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
 }
}
//RECIPE

//SECRETSTORE
resource secretStoreGithub 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'github'
  properties:{
    type: 'generic'
    data: {
      // Call it out in the documentation that pat is a required key value
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
