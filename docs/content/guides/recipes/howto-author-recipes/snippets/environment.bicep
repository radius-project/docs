extension radius

resource env 'Applications.Core/environments@2023-10-01-preview' = {
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
          templatePath: 'https://ghcr.io/USERNAME/recipes/myrecipe:1.1.0'
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
