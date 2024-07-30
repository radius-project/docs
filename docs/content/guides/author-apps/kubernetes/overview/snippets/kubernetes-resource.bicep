extension kubernetes with {
  kubeConfig: '****'
  namespace: 'default'
}

resource pod 'core/Pod@v1' = {
  metadata: {
    name: 'mypod'
  }
  spec: {
    containers: [
      {
        name: 'web-server'
        image: 'nginx:latest'
        ports: [
          {
            containerPort: 80
          }
        ]
      }
    ]
  }
}
