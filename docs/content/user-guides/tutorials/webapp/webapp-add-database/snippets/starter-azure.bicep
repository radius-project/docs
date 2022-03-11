//APP
resource app 'radius.dev/Application@v1alpha3' = {
  name: 'todoapp'

  //CONTAINER
  resource todoFrontend 'Container' = {
    name: 'frontend'
    properties: {
      //IMAGE
      container: {
        image: 'radius.azurecr.io/webapptutorial-todoapp'
      }
      //IMAGE
      connections: {
        itemstore: {
          kind: 'mongo.com/MongoDB'
          source: db.id
        }
      }
    }
    dependsOn: [
      dbStarter
    ]
  }
  //CONTAINER
  // Temporary workaround
  resource db 'mongo.com.MongoDatabase' existing = {
    name: 'db'
  }
}
//APP

//STARTER
module dbStarter 'br:radius.azurecr.io/starters/mongo-azure:latest' = {
  name: 'db-starter'
  params: {
    dbName: 'db'
    radiusApplication: app
  }
}
//STARTER
