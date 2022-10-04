import radius as radius

param radEnvironment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

//SQL
resource db 'Applications.Connector/sqlDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: 'global'
  properties: {
    environment: radEnvironment
    application: app.id
    server: 'https://sql.contoso.com'
    database: 'inventory'
  }
}
//SQL
