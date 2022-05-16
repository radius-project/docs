resource app 'radius.dev/Application@v1alpha3' = {
  name: 'myapp'

  //HTTPROUTE
  resource httproute 'HttpRoute' = {
    name: 'httproute'
  }
  //HTTPROUTE

  //FRONTEND
  resource frontend 'Container' = {
    name: 'frontend'
    properties: {
      container: {
        image: 'registry/container:tag'
        env: {
          BACKEND_URL: httproute.properties.url
        }
      }
      connections: {
        http: {
          kind: 'Http'
          source: httproute.id
        }
      }
    }
  }
  //FRONTEND

  //BACKEND
  resource backend 'Container' = {
    name: 'backend'
    properties: {
      container: {
        image: 'registry/container:tag'
        ports: {
          http: {
            containerPort: 80
            provides: httproute.id
          }
        }
      }
    }
  }
  //BACKEND
}
