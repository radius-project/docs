import radius as radius

@description('The ID of your Radius environment. Automatically injected by the rad CLI.')
param environment string

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: 'mycosmos'

  resource database 'mongodbDatabases' existing = {
    name: 'mydb'
  }

}

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'cosmos-container-usermanaged'
  properties: {
    environment: environment
  }
}

//MONGO
resource db 'Applications.Link/mongoDatabases@2022-03-15-privatepreview' = {
  name: 'db'
  properties: {
    environment: environment
    application: app.id
    resourceProvisioning: 'manual'
    host: split(substring(cosmosAccount.properties.documentEndpoint, indexOf(cosmosAccount.properties.documentEndpoint, ':') + 2), ':')[0]
    port: int(substring(cosmosAccount.properties.documentEndpoint,lastIndexOf(cosmosAccount.properties.documentEndpoint, ':') + 1))
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