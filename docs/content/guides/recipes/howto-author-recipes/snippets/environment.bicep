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
      'Applications.Datastores/redisCaches':{
        'redis-bicep': {
          templateKind: 'bicep'
          templatePath: 'https://myregistry.azurecr.io/recipes/myrecipe:1.1.0'
          // Optionally set parameters for all resources calling this Recipe
          parameters: {
            port: 3000
          }
        }
        'redis-terraform': {
          templateKind: 'terraform'
          templatePath: 'user/recipes/myrecipe'
          templateVersion: '1.1.0'
          // Optionally set parameters for all resources calling this Recipe
          parameters: {
            port: 3000
          }
        }
      }
    }
  }
}
