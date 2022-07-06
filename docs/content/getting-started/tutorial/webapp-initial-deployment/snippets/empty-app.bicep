import radius as radius

param environment string

param location string = 'global'

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'todoapp'
  location: location
  properties: {
    environment: environment
  }
}
