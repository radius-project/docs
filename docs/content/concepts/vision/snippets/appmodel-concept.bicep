// Define app 
resource app 'radius.dev/Application@v1alpha3' = {
  name: 'webapp'

  // Define container resource to run app code
  resource todoapplication 'Container' = {
    name: 'todoapp'
    properties: {
      container: {
        image: 'radius.azurecr.io/webapptutorial-todoapp'
        ports: {
          web: {
            containerPort: 3000
          }
        }
      }
      // Connect container to database 
      connections: {
        itemstore: {
          kind: 'mongo.com/MongoDB'
          source: db.id
        }
      }
    }
    dependsOn: [
      mongoDb
    ]
  }
 
  // Define database
  resource db 'mongo.com.MongoDatabase' existing =  {
    name: 'db'
  }
}

module mongoDb 'br:radius.azurecr.io/starters/mongo:latest' = {
  name: 'mongoDb'
  params: {
    radiusApplication: app
    dbName: 'db'
  }
}

