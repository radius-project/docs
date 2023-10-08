import radius as rad

@description('Environment ID being deployed into. Set automatically by the rad CLI')
param environment string

@description('Application ID being deployed. Set automatically by the rad CLI.')
param application string

resource db1 'Applications.Datastores/sqlDatabases@2023-10-01-preview' = {
  name: 'db1'
  properties: {
    environment: environment
    application: application
  }
}

resource db2 'Applications.Datastores/sqlDatabases@2023-10-01-preview' = {
  name: 'db2'
  properties: {
    environment: environment
    application: application
  }
}
