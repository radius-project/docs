import radius as radius
param application string
param environment string

resource demo 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'demo'
  location: 'global'
  properties: {
    application: application
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    connections: {
      redis: {
        source: db.id
      }
    }
  }
}

resource db 'Applications.Link/redisCaches@2022-03-15-privatepreview' = {
  name: 'db'
  location: 'global'
  properties: {
    application: application
    environment: environment
    mode: 'recipe'
    recipe: {
      name: 'redis-kubernetes'
    }
  }
}
