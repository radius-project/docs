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
            'my-access-token':{
              'github.com':{
                secret: secretStoreGithub.id
              }
            }
          }          
        }
      }
    }
    recipes: {      
      'Applications.Datastores/mongoDatabases':{
          default: {
            templateKind: 'terraform'
            templatePath: 'https://dev.azure.com/test-private-repo'
          }
      }
    }
 }
}
//ENV     

//SECRETSTORE
resource secretStoreGithub 'Applications.Core/secretStores@2023-10-01-preview' = {
  name: 'github'
  properties:{
    type: 'generic'
    data: {
      'my-access-token': {
        value: '<personal-access-token>'
      }
      'my-username': {
        value: '<username>'
      }
    }
  }
}
//SECRETSTORE
