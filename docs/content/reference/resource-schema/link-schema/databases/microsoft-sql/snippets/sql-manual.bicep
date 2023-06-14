import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container'
  properties: {
    environment: environment
  }
}

resource sqldb 'Microsoft.Sql/servers@2021-02-01-preview' existing = {
  name: 'sqldb'
  resource dbinner 'databases' existing = {
    name: 'cool-database'
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
        id: sqldb::dbinner.id
      }
    ]
    server: sqldb.properties.fullyQualifiedDomainName
    database: sqldb::dbinner.name
  }
}
//SQL
