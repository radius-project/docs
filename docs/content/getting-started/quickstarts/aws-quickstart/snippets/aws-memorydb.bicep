import aws as aws

param eksClusterName string

resource eksCluster 'AWS.EKS/Cluster@default' existing = {
  name: eksClusterName
}

param subnetGroupName string = 'demo-memorydb-subnet-group'
resource subnetGroup 'AWS.MemoryDB/SubnetGroup@default' = {
  name: subnetGroupName
  properties: {
    SubnetGroupName: subnetGroupName
    SubnetIds: eksCluster.properties.ResourcesVpcConfig.SubnetIds
  }
}

param memoryDBClusterName string = 'demo-memorydb-cluster'
resource memoryDBCluster 'AWS.MemoryDB/Cluster@default' = {
  name: memoryDBClusterName
  properties: {
    ClusterName: memoryDBClusterName
    NodeType: 'db.t4g.small'
    ACLName: 'open-access'
    SecurityGroupIds: [eksCluster.properties.ClusterSecurityGroupId]
    SubnetGroupName: subnetGroup.name
  }
}

output memoryDBConnectionString string = 'rediss://${memoryDBCluster.properties.ClusterEndpoint.Address}:${memoryDBCluster.properties.ClusterEndpoint.Port}'
