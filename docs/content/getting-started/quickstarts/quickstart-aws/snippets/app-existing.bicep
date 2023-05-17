import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'webapp'
  properties: {
    environment: environment
  }
}

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
    }
    connections: {
      redis: {
        source: db.id
      }
    }
  }
}

resource db 'Applications.Link/redisCaches@2022-03-15-privatepreview' = {
  name: 'db'
  properties: {
    environment: environment
    resourceProvisioning: 'manual'
    host: memoryDB.outputs.memoryDBHost
    port: memoryDB.outputs.memoryDBPort
    secrets: {
      connectionString: memoryDB.outputs.memoryDBConnectionString
    }
  }
}

module memoryDB 'aws-memorydb-existing.bicep' = {
  name: 'memorydb-module'
}

