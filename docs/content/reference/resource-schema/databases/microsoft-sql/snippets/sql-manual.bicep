extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string
param username string
param port int

@secure()
param password string

resource app 'Applications.Core/applications@2023-10-01-preview' = {
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
resource db 'Applications.Datastores/sqlDatabases@2023-10-01-preview' = {
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
    port: port
    username: username
    secrets:{
      password: password
      connectionString: 'Data Source=tcp:${sqldb.properties.fullyQualifiedDomainName},${port};Initial Catalog=${sqldb::dbinner.name};User Id=${username};Password=${password};Encrypt=True;TrustServerCertificate=True'
    }
  }
}
//SQL
