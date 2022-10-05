import radius as radius

param environmentId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container'
  location: 'global'
  properties: {
    environment: environmentId
  }
}

//SQL
resource db 'Applications.Connector/sqlDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: 'global'
  properties: {
    environment: environmentId
    application: app.id
    server: 'https://sql.contoso.com'
    database: 'inventory'
  }
}
//SQL
