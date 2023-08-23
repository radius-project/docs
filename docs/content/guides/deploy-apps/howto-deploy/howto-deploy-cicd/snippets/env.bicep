import radius as rad

resource environment 'Applications.Core/environments@2022-03-15-privatepreview' = {
  name: 'myenv'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'default'
    }
  }
}
