import radius as radius

param environmentId string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'my-app'
  location: 'global'
  properties: {
    environment: environmentId
  }
}
