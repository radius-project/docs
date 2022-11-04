import radius as radius

param environment string

param sqldb string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container'
  location: 'global'
  properties: {
    environment: environment
  }
}

//SQL
resource db 'Applications.Link/sqlDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  location: 'global'
  properties: {
    environment: environment
    application: app.id
    mode: 'resource'
    resource: sqldb
  }
}
//SQL
