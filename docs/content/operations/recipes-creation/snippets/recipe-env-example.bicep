import radius as radius

param rg string = resourceGroup().name

param sub string = subscription().subscriptionId

resource env 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'prod'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'
      resourceId: 'self'
      namespace: 'context-env'
    }
    providers: {
      azure: {
        scope: '/subscriptions/${sub}/resourceGroups/${rg}'
      }
    }
    recipes: {
      mongodb: {
          linkType: 'Applications.Link/mongoDatabases' 
          templatePath: 'prod/recipes/functionaltest/context/mongodatabases/azure:1.0' 
      }
    }
  }
}
