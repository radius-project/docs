extension radius

//RECIPEPACK
resource postgresqlPack 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'postgresqlPack'
  properties: {
    recipes: {
      'Radius.Data/postgreSqlDatabases': {
        recipeKind: 'terraform'
        recipeLocation: 'git::https://github.com/radius-project/docs.git//docs/content/tutorials/create-recipe/recipes/terraform'
      }
    }
  }
}
//RECIPEPACK

//ENVIRONMENT
resource env 'Radius.Core/environments@2025-08-01-preview' = {
  name: 'my-env'
  properties: {
    recipePacks: [
      postgresqlPack.id
    ]
    providers: {
      kubernetes: {
        namespace: 'my-env'
      }
    }
  }
}
//ENVIRONMENT
