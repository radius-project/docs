resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  resource mongoConnector 'mongo.com.MongoDatabase' existing = {
    name: 'orders'
  }

}

module mongoDB 'br:radius.azurecr.io/starters/mongo-azure:latest' = {
  name: 'mongoDb'
  params: {
    radiusApplication: app
    dbName: 'orders'
  }
}
