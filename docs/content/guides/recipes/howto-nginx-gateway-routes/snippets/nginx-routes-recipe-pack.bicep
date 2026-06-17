extension radius

param recipeTag string = '0.58'

resource recipePack 'Radius.Core/recipePacks@2025-08-01-preview' = {
  name: 'nginx-gateway'
  location: 'global'
  properties: {
    recipes: {
      'Radius.Compute/containers': {
        recipeKind: 'bicep'
        recipeLocation: 'ghcr.io/radius-project/kube-recipes/containers:${recipeTag}'
      }
      'Radius.Compute/routes': {
        recipeKind: 'bicep'
        recipeLocation: 'ghcr.io/radius-project/kube-recipes/routes:${recipeTag}'
        parameters: {
          gatewayName: 'radius'
          gatewayNamespace: 'nginx-radius-demo'
        }
      }
    }
  }
}
