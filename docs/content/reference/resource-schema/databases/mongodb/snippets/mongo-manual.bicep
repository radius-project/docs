extension radius

@description('The ID of your Radius Environment. Automatically injected by the rad CLI.')
param environment string

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: 'mycosmos'

  resource database 'mongodbDatabases' existing = {
    name: 'mydb'
  }

}

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'cosmos-container-usermanaged'
  properties: {
    environment: environment
  }
}

//MONGO
resource db 'Applications.Datastores/mongoDatabases@2023-10-01-preview' = {
  name: 'db'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    host: substring(cosmosAccount.properties.documentEndpoint, 0, lastIndexOf(cosmosAccount.properties.documentEndpoint, ':'))
    port: int(split(substring(cosmosAccount.properties.documentEndpoint,lastIndexOf(cosmosAccount.properties.documentEndpoint, ':') + 1), '/')[0])
    database: cosmosAccount::database.name
    username: ''
    resources: [
      { id: cosmosAccount.id }
    ]
    secrets: {
      connectionString: cosmosAccount.listConnectionStrings().connectionStrings[0].connectionString
      password: base64ToString(cosmosAccount.listKeys().primaryMasterKey)
    }
  }
}
//MONGO
