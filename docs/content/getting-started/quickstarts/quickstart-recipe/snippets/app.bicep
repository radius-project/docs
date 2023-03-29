import radius as radius
param application string
param environment string

//TODO rewrite for all options
resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'webapp'
  location: location
  properties: {
    environment: environment
  }
}

resource frontend 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'frontend'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'radius.azurecr.io/tutorial/webapp:edge'
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
      name: ''
    }
  }
}
