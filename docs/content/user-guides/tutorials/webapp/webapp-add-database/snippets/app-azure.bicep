resource app 'radius.dev/Application@v1alpha3' = {
  name: 'todoapp'

  resource todoFrontend 'Container' = {
    name: 'frontend'
    properties: {
      container: {
        image: 'radius.azurecr.io/webapptutorial-todoapp'
        ports: {
          web: {
            containerPort: 3000
            provides: todoRoute.id
          }
        }
      }
      connections: {
        itemstore: {
          kind: 'mongo.com/MongoDB'
          source: db.id
        }
      }
    }
    // This manual dependency is currently required, will be removed in a future release
    dependsOn: [
      dbStarter
    ]
  }

  resource todoRoute 'HttpRoute' = {
    name: 'frontend-route'
  }

  resource todoGateway 'Gateway' = {
    name: 'gateway'
    properties: {
      routes: [
        {
          path: '/'
          destination: todoRoute.id
        }
      ]
    }
  }

  // This temporary existing reference points to the Mongo Starter deployed by the starter
  resource db 'mongo.com.MongoDatabase' existing = {
    name: 'db'
  }

}

// This module deploys an Azure CosmosDB w/ Mongo API
module dbStarter 'br:radius.azurecr.io/starters/mongo-azure:latest' = {
  name: 'db-starter'
  params: {
    dbName: 'db'
    radiusApplication: app
  }
}
