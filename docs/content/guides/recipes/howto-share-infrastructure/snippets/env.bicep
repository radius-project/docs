import radius as rad

resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'demo-shared-env'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: 'default'
    }
  }
}
