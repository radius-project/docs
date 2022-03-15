resource app 'radius.dev/Application@v1alpha3' = {
  name: 'todoapp'

  resource todoRoute 'HttpRoute' = {
    name: 'frontend-route'
    properties: {
      gateway: {
        hostname: '*'
      }
    }
  }

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
  
}
