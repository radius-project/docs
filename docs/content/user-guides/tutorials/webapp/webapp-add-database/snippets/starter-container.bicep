resource app 'radius.dev/Application@v1alpha3' = {
  name: 'todoapp'
}

//STARTER
module dbStarter 'br:radius.azurecr.io/starters/mongo:latest' = {
  name: 'db-starter'
  params: {
    dbName: 'db'
    radiusApplication: app
  }
}
//STARTER
