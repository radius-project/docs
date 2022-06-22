// Use this file to declare your application and the relationships between its services
// using Radius.

// You can declare parameters to pass in resources created by infra.bicep or infra.dev.bicep
// param database_name string 
param node_build object

resource app 'radius.dev/Application@v1alpha3' = {
  name: 'code'

  // Creates a container to run the radius.azurecr.io/webapptutorial-todoapp
  // image
  resource demo 'Container' = {
    name: 'demo'
    properties: {
      container: {
        image: node_build.image
        ports: {
          web: {
            containerPort: 8080
            provides: route.id
          }
        }
      }
    }
  }

  // Creates a route to bind requests from the gateway to a service.
  resource route 'HttpRoute' = {
    name: 'route'
  }

  // Creates a gateway to accept HTTP traffic from the internet.
  resource gateway 'Gateway' = {
    name: 'web'
    properties: {
      routes: [
        {
          path: '/'
          destination: route.id
        }
      ]
    }
  }
}
