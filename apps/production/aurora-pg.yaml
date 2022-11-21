apiVersion: v1
kind: Secret
metadata:
    name: aurora-pg-password
    namespace: retailapp
type: Opaque
data:
    password: cG9zdGdyZXM=
---
apiVersion: rds.services.k8s.aws/v1alpha1
kind: DBCluster
metadata:
  name: ack-db
  namespace: retailapp
spec:
  backupRetentionPeriod: 7
  serverlessV2ScalingConfiguration:
    maxCapacity: 4
    minCapacity: 0.5
  dbClusterIdentifier: ack-db
  dbSubnetGroupName: <dbSubnetGroupName>
  engine: aurora-postgresql
  engineVersion: "13"
  masterUsername: adminer
  masterUserPassword:
    namespace: retailapp
    name: aurora-pg-password
    key: password
  vpcSecurityGroupIDs:
     -  <vpcSecurityGroupIDs>
---
apiVersion: rds.services.k8s.aws/v1alpha1
kind: DBInstance
metadata:
  name: ack-db-instance01
  namespace: retailapp
spec:
  dbInstanceClass: db.serverless
  dbInstanceIdentifier: ack-db-instance01
  dbClusterIdentifier: ack-db
  dbSubnetGroupName: <dbSubnetGroupName>
  engine: aurora-postgresql
  engineVersion: "13"
  publiclyAccessible: false
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: asv2-db-instance-conn-cm
  namespace: retailapp
data: {}
---
apiVersion: services.k8s.aws/v1alpha1
kind: FieldExport
metadata:
  name: ack-db-instance01-host
  namespace: retailapp
spec:
  to:
    name: asv2-db-instance-conn-cm
    kind: configmap
  from:
    path: ".status.endpoint.address"
    resource:
      group: rds.services.k8s.aws
      kind: DBInstance
      name: ack-db-instance01
---
apiVersion: services.k8s.aws/v1alpha1
kind: FieldExport
metadata:
  name: ack-db-instance01-port
  namespace: retailapp
spec:
  to:
    name: asv2-db-instance-conn-cm
    kind: configmap
  from:
    path: ".status.endpoint.port"
    resource:
      group: rds.services.k8s.aws
      kind: DBInstance
      name: ack-db-instance01
---
apiVersion: services.k8s.aws/v1alpha1
kind: FieldExport
metadata:
  name: ack-db-instance01-user
  namespace: retailapp
spec:
  to:
    name: asv2-db-instance-conn-cm
    kind: configmap
  from:
    path: ".spec.masterUsername"
    resource:
      group: rds.services.k8s.aws
      kind: DBInstance
      name: ack-db-instance01
