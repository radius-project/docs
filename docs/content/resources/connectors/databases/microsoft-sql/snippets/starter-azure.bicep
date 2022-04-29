resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  resource sqlConnector 'microsoft.com.SQLDatabase' existing = {
    name: 'inventory'
  }
}

module sqlDb 'br:radius.azurecr.io/starters/sql-azure:latest' = {
  name: 'sqlDb'
  params: {
    radiusApplication: app
    databaseName: 'inventory'
    adminUsername: 'admin'
    adminPassword: '***'
  }
}
