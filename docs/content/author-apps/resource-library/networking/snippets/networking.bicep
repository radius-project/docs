resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  resource serviceA 'Container' = {
    name: 'service-a'
    properties: {
      container: {
        image: 'servicea'
        ports: {
          web: {
            containerPort: 80
            provides: routeAWeb.id
          }
          api: {
            containerPort: 3000
            provides: routeAApi.id
          }
        }
      }
      connections: {
        serviceB: {
          kind: 'Http'
          source: routeB.id
        }
      }
    }
  }

  resource routeAWeb 'HttpRoute' = {
    name: 'route-a-web'
  }

  resource routeAApi 'HttpRoute' = {
    name: 'route-a-api'
  }

  resource serviceB 'Container' = {
    name: 'service-b'
    properties: {
      container: {
        image: 'serviceb'
        ports: {
          api: {
            containerPort: 3000
            provides: routeB.id
          }
        }
      }
      connections: {
        serviceA: {
          kind: 'Http'
          source: routeAApi.id
        }
      }
    }
  }
  
  resource routeB 'HttpRoute' = {
    name: 'route-b'
  }

  resource internetGateway 'Gateway' = {
    name: 'internet-gateway'
    properties: {
      routes: [
        {
          path: '/'
          destination: routeAWeb.id
        }
      ]
    }
  }

}
