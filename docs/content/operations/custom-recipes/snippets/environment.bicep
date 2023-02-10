import radius as radius

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'prod'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'
      resourceId: 'self'
      namespace: 'default'
    }
    recipes: {
      myrecipe: {
          linkType: 'Applications.Link/redisCaches' 
          templatePath: 'https://myregistry.azurecr.io/recipes/myrecipe:v1' 
      }
    }
  }
}
