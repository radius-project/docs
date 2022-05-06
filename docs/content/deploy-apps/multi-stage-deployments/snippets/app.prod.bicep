resource app 'radius.dev/Application@v1alpha3' = {
  name: 'my-app'

  // Creates a container to run the radius.azurecr.io/webapptutorial-todoapp
  // image
  resource demo 'Container' = {
    name: 'demo'
    properties: {
      container: {
        image: 'radius.azurecr.io/webapptutorial-todoapp'
        ports: {
          web: {
            containerPort: 3000
            provides: web.id
          }
        }
      }
      connections: {
        mongo: {
          kind: 'mongo.com/MongoDB'
          source: mongoConnector.id
        }
      }
    }
  }

  // Create a route to accept HTTP traffic from the internet.
  // Remove the 'gateway' section to use as an internal route.
  resource web 'HttpRoute' = {
    name: 'web'
  }

  resource gateway 'Gateway' = {
    name: 'gateway'
    properties: {
      routes: [
        {
          path: '/'
          destination: web.id
        }
      ]
    }
  }

  resource mongoConnector 'mongo.com.MongoDatabase' existing = {
    name: 'todo-items'
  }
}

module mongoDb 'br:radius.azurecr.io/starters/mongo:latest' = {
  name: 'mongoDb'
  params: {
    radiusApplication: app
    dbName: 'todo-items'
  }
}
