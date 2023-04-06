import aws as aws

@description('Name of the EKS cluster used for app deployment')
param eksClusterName string

// Reference the existing EKS cluster using the 'existing' keyword to provision the MemoryDB cluster in the same VPC and subnet as the EKS cluster
resource eksCluster 'AWS.EKS/Cluster@default' existing = {
  alias: eksClusterName
  properties: {
    Name: eksClusterName
  }
}

@description('Name of the subnet group for the MemoryDB cluster')
param subnetGroupName string = 'demo-memorydb-subnet-group'

// Create a subnetgroup with the VPC and subnet IDs from the EKS cluster.
resource subnetGroup 'AWS.MemoryDB/SubnetGroup@default' = {
  alias:subnetGroupName
  properties: {
    SubnetGroupName: subnetGroupName
    SubnetIds: eksCluster.properties.ResourcesVpcConfig.SubnetIds
  }
}

@description('Name of the MemoryDb cluster')
param memoryDBClusterName string = 'demo-memorydb-cluster'

// Create a MemoryDB clsuster with subnetgroupName that was created before and the EKS cluster security group ID to enable the cluster connect to MemoryDB .
resource memoryDBCluster 'AWS.MemoryDB/Cluster@default' = {
  alias: memoryDBClusterName
  properties: {
    ClusterName: memoryDBClusterName
    NodeType: 'db.t4g.small'
    ACLName: 'open-access'
    SecurityGroupIds: [eksCluster.properties.ClusterSecurityGroupId]
    SubnetGroupName: subnetGroup.name
    NumReplicasPerShard: 0
  }
}

// Use the output keyword to expose values to the parent module. This allows you to use the module in a nested fashion.
output memoryDBConnectionString string = 'rediss://${memoryDBCluster.properties.ClusterEndpoint.Address}:${memoryDBCluster.properties.ClusterEndpoint.Port}'
output memoryDBHost string = memoryDBCluster.properties.ClusterEndpoint.Address
output memoryDBPort int = memoryDBCluster.properties.ClusterEndpoint.Port
