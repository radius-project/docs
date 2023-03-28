import radius as rad

resource environment 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'myenv'
  location: 'global'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'default'
    }
  }
}
