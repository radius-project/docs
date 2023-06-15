import radius as radius

param environment string
param username string
param port string

@secure()
param password string

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
    server: 'https://sql.contoso.com'
    database: 'inventory'
    port: port
    username: username
    secrets:{
      password: password
    }
  }
}
//SQL
