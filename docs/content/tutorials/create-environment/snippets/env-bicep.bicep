extension radius

//RECIPEPACK
resource postgresqlPack 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'postgresqlPack'
  properties: {
    recipes: {
      'Radius.Data/postgreSqlDatabases': {
        recipeKind: 'bicep'
        recipeLocation: 'ghcr.io/radius-project/recipes/kubernetes/postgresql:latest'
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
