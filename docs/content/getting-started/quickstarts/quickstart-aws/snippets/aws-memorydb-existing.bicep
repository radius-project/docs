import aws as aws

param memoryDBClusterName string = 'demo-memorydb-cluster'
resource memoryDBCluster 'AWS.MemoryDB/Cluster@default' existing = {
  alias: memoryDBClusterName
  properties: {
    ClusterName: memoryDBClusterName
  }
}

output memoryDBConnectionString string = 'rediss://${memoryDBCluster.properties.ClusterEndpoint.Address}:${memoryDBCluster.properties.ClusterEndpoint.Port}'
output memoryDBHost string = memoryDBCluster.properties.ClusterEndpoint.Address
output memoryDBPort int = memoryDBCluster.properties.ClusterEndpoint.Port
