import radius as radius

param environment string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'store'
  location: 'global'
  properties: {
    environment: environment
  }
}
