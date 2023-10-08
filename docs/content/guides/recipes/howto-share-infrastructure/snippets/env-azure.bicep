import radius as rad

//ENVIRONMENT
resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'demo-shared-env'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'default'
    }
    recipes: {
      'Applications.Datastores/sqlServers': {
        'default': {
          templateKind: 'bicep'
          templatePath: 'radius.azurecr.io/recipes/azure/shared-sql:latest'
          parameters: {
            // Set the sqlServerName parameter for every Recipe usage
            sqlServerName: sqlServer.name
          }
        }
      }
    }
  }
}
//ENVIRONMENT

//SQL
resource sqlServer 'Microsoft.SQL/servers' = {
  name: 'shared-sql'
  //TODO
}
//SQL
