extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'cosmos-container'
  properties: {
    environment: environment
  }
}

//SQL
resource db 'Applications.Datastores/sqlDatabases@2023-10-01-preview' = {
  name: 'db'
  properties: {
    environment: environment
    application: app.id
    recipe: {
      // Name a specific Recipe to use
      name: 'azure-sqldb'
      // Optionally set recipe parameters if needed (specific to the Recipe)
      parameters: {
        server: '*******'
      }
    }
  }
}
//SQL
