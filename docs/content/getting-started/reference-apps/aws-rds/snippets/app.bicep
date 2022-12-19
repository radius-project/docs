import radius as radius
import aws as aws

param location string = 'global'
param environment string

param databaseName string = 'wordpress'
param databaseUsername string = 'admin'

@secure()
param databasePassword string

resource app 'Applications.Core/applications@2022-03-15-privatepreview' = {
  name: 'wordpress-app'
  location: location
  properties: {
    environment: environment
  }
}

resource wordpress 'Applications.Core/containers@2022-03-15-privatepreview' = {
  name: 'wordpress-container'
  location: location
  properties: {
    application: app.id
    container: {
      image: 'wordpress:6.1.1'
      ports: {
        web: {
          containerPort: 80
        }
      }
      env: {
        WORDPRESS_DB_HOST: '${db.properties.Endpoint.Address}:${db.properties.Endpoint.Port}'
        WORDPRESS_DB_USER: databaseUsername
        WORDPRESS_DB_PASSWORD: databasePassword
        WORDPRESS_DB_NAME: databaseName
      }
    }
  }
}

param eksClusterName string = 'willsmith-eks-env'
resource eksCluster 'AWS.EKS/Cluster@default' existing = {
  properties: {
    Name: eksClusterName
  }
}

param subnetGroupName string = 'wordpress-subnetgroup-2'
resource subnetGroup 'AWS.RDS/DBSubnetGroup@default' = {
  properties: {
    DBSubnetGroupName: subnetGroupName
    DBSubnetGroupDescription: subnetGroupName
    SubnetIds: eksCluster.properties.ResourcesVpcConfig.SubnetIds
  }
}

param databaseIdentifier string = 'wordpress-db-2'
resource db 'AWS.RDS/DBInstance@default' = {
  properties: {
    DBInstanceIdentifier: databaseIdentifier
    Engine: 'mysql'
    DBInstanceClass: 'db.t3.micro'
    AllocatedStorage: '20'
    DBName: databaseName
    VPCSecurityGroups: [eksCluster.properties.ClusterSecurityGroupId]
    DBSubnetGroupName: subnetGroup.properties.DBSubnetGroupName
    MasterUsername: databaseUsername
    MasterUserPassword: databasePassword
  }
}
