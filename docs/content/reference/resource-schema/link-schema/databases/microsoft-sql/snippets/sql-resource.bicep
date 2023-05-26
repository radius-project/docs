import radius as radius

param environment string

param sqldb string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container'
  properties: {
    environment: environment
  }
}

//SQL
resource db 'Applications.Link/sqlDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    resources:[
      {
        id: sqldb
      }
    ]
    server: 'https://sql.contoso.com'
    database: 'inventory'
  }
}
//SQL
