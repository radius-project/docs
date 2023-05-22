import radius as radius

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'prod'
  properties: {
    compute: {
      kind: 'kubernetes'
      resourceId: 'self'
      namespace: 'default'
    }
    recipes: {
      'Applications.Link/redisCaches':{
        myrecipe: {
          templateKind: 'bicep'
          templatePath: 'https://myregistry.azurecr.io/recipes/myrecipe:v1'
          // Optionally set parameters for all resources calling this Recipe
          parameters: {
            capacity: 1
          }
        }
      }
    }
  }
}
