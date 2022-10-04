import radius as radius

param radEnvironment string

resource myapp 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'my-application'
  location: 'global'
  properties: {
    environment: radEnvironment
  }
}

//RESOURCES
//RESOURCES
