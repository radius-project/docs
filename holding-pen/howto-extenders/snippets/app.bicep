extension radius

@description('The ID of your Radius environment. Set automatically by the rad CLI.')
param environment string

@description('The ID of your Radius application. Set automatically by the rad CLI.')
param application string

resource extender 'Applications.Core/extenders@2023-10-01-preview' = {
  name: 'postgresql'
  properties: {
    environment: environment
    application: application
    recipe: {
      name: 'postgresql'
    }
  }
}
