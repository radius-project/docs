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
    }
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
  
}
