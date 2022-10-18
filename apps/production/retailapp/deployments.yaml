apiVersion: apps/v1
kind: Deployment
metadata:
  name: kart
  namespace: retailapp
  labels:
    app: eksack
    service: kart
spec:
  replicas: 1
  strategy:
    rollingUpdate:
      maxSurge: 3
      maxUnavailable: 0
  selector:
    matchLabels:
      app: eksack
      service: kart
  template:
    metadata:
      labels:
        app: eksack
        service: kart
    spec:
      restartPolicy: Always
      containers:
      - name: kart
        image: <account_id>.dkr.ecr.<region>.amazonaws.com/eksack/kart:1.0
        imagePullPolicy: Always
        ports:
         - containerPort: 8445
        env:
          - name: DATABASE_HOST
            valueFrom:
              configMapKeyRef:
                 name: asv2-db-instance-conn-cm
                 key: retailapp.ack-db-instance01-host
          - name: DATABASE_PORT
            valueFrom:
              configMapKeyRef:
                 name: asv2-db-instance-conn-cm
                 key: retailapp.ack-db-instance01-port
          - name: DATABASE_USER
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_user
          - name: DATABASE_PASSWORD
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_password
          - name: DATABASE_DB_NAME
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_db_name
          - name: DATABASE_RODB_NAME
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_rodb_name
          - name: SECRET_KEY
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: secret_key
          - name: AUTHTOKEN
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: authtoken
          - name: MEMDB_HOST
            valueFrom:
              configMapKeyRef:
                 name: memorydb-cluster-conn-cm
                 key: retailapp.memorydb-cluster-host
          - name: MEMDB_PORT
            valueFrom:
              configMapKeyRef:
                 name: memorydb-cluster-conn-cm
                 key: retailapp.memorydb-cluster-port
          - name: MEMDB_USER
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: memdb_user
          - name: MEMDB_PASS
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: memdb_pass
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product
  namespace: retailapp
  labels:
    app: eksack
    service: product
spec:
  replicas: 1
  strategy:
    rollingUpdate:
      maxSurge: 3
      maxUnavailable: 0
  selector:
    matchLabels:
      app: eksack
      service: product
  template:
    metadata:
      labels:
        app: eksack
        service: product
    spec:
      restartPolicy: Always
      containers:
      - name: product
        image: <account_id>.dkr.ecr.<region>.amazonaws.com/eksack/product:1.0
        imagePullPolicy: Always
        ports:
         - containerPort: 8444
        env:
          - name: DATABASE_HOST
            valueFrom:
              configMapKeyRef:
                 name: asv2-db-instance-conn-cm
                 key: retailapp.ack-db-instance01-host
          - name: DATABASE_PORT
            valueFrom:
              configMapKeyRef:
                 name: asv2-db-instance-conn-cm
                 key: retailapp.ack-db-instance01-port
          - name: DATABASE_USER
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_user
          - name: DATABASE_PASSWORD
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_password
          - name: DATABASE_DB_NAME
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_db_name
          - name: DATABASE_RODB_NAME
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_rodb_name
          - name: SECRET_KEY
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: secret_key
          - name: AUTHTOKEN
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: authtoken
          - name: MEMDB_HOST
            valueFrom:
              configMapKeyRef:
                 name: memorydb-cluster-conn-cm
                 key: retailapp.memorydb-cluster-host
          - name: MEMDB_PORT
            valueFrom:
              configMapKeyRef:
                 name: memorydb-cluster-conn-cm
                 key: retailapp.memorydb-cluster-port
          - name: MEMDB_USER
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: memdb_user
          - name: MEMDB_PASS
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: memdb_pass
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user
  namespace: retailapp
  labels:
    app: eksack
    service: user
spec:
  replicas: 1
  strategy:
    rollingUpdate:
      maxSurge: 3
      maxUnavailable: 0
  selector:
    matchLabels:
      app: eksack
      service: user
  template:
    metadata:
      labels:
        app: eksack
        service: user
    spec:
      restartPolicy: Always
      containers:
      - name: user
        image: <account_id>.dkr.ecr.<region>.amazonaws.com/eksack/user:1.0
        imagePullPolicy: Always
        ports:
         - containerPort: 8446
        env:
          - name: DATABASE_HOST
            valueFrom:
              configMapKeyRef:
                 name: asv2-db-instance-conn-cm
                 key: retailapp.ack-db-instance01-host
          - name: DATABASE_PORT
            valueFrom:
              configMapKeyRef:
                 name: asv2-db-instance-conn-cm
                 key: retailapp.ack-db-instance01-port
          - name: DATABASE_USER
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_user
          - name: DATABASE_PASSWORD
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_password
          - name: DATABASE_DB_NAME
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_db_name
          - name: DATABASE_RODB_NAME
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_rodb_name
          - name: SECRET_KEY
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: secret_key
          - name: AUTHTOKEN
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: authtoken
          - name: MEMDB_HOST
            valueFrom:
              configMapKeyRef:
                 name: memorydb-cluster-conn-cm
                 key: retailapp.memorydb-cluster-host
          - name: MEMDB_PORT
            valueFrom:
              configMapKeyRef:
                 name: memorydb-cluster-conn-cm
                 key: retailapp.memorydb-cluster-port
          - name: MEMDB_USER
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: memdb_user
          - name: MEMDB_PASS
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: memdb_pass
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: retailapp
  labels:
    app: eksack
    service: webapp
spec:
  replicas: 1
  strategy:
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 0
  selector:
    matchLabels:
      app: eksack
      service: webapp
  template:
    metadata:
      labels:
        app: eksack
        service: webapp
    spec:
      restartPolicy: Always
      containers:
      - name: webapp
        image: <account_id>.dkr.ecr.<region>.amazonaws.com/eksack/webapp:1.0
        imagePullPolicy: Always
        ports:
         - containerPort: 8443
        env:
          - name: DATABASE_HOST
            valueFrom:
              configMapKeyRef:
                 name: asv2-db-instance-conn-cm
                 key: retailapp.ack-db-instance01-host
          - name: DATABASE_PORT
            valueFrom:
              configMapKeyRef:
                 name: asv2-db-instance-conn-cm
                 key: retailapp.ack-db-instance01-port
          - name: DATABASE_USER
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_user
          - name: DATABASE_PASSWORD
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_password
          - name: DATABASE_DB_NAME
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_db_name
          - name: DATABASE_RODB_NAME
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_rodb_name
          - name: SECRET_KEY
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: secret_key
          - name: AUTHTOKEN
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: authtoken
          - name: PRODUCTS_SERVICE
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: product_service
          - name: KART_SERVICE
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: kart_service
          - name: USER_SERVICE
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: user_service
          - name: ORDER_SERVICE
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: order_service
          - name: MEMDB_HOST
            valueFrom:
              configMapKeyRef:
                 name: memorydb-cluster-conn-cm
                 key: retailapp.memorydb-cluster-host
          - name: MEMDB_PORT
            valueFrom:
              configMapKeyRef:
                 name: memorydb-cluster-conn-cm
                 key: retailapp.memorydb-cluster-port
          - name: MEMDB_USER
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: memdb_user
          - name: MEMDB_PASS
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: memdb_pass
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: order-deployment
  namespace: retailapp
  labels:
    app: eksack
    service: order
spec:
  replicas: 1
  strategy:
    rollingUpdate:
      maxSurge: 3
      maxUnavailable: 0
  selector:
    matchLabels:
      app: eksack
      service: order
  template:
    metadata:
      labels:
        app: eksack
        service: order
    spec:
      restartPolicy: Always
      containers:
      - name: order
        image: <account_id>.dkr.ecr.<region>.amazonaws.com/eksack/order:1.0
        imagePullPolicy: Always
        ports:
         - containerPort: 8448
        env:
          - name: DATABASE_HOST
            valueFrom:
              configMapKeyRef:
                 name: asv2-db-instance-conn-cm
                 key: retailapp.ack-db-instance01-host
          - name: DATABASE_PORT
            valueFrom:
              configMapKeyRef:
                 name: asv2-db-instance-conn-cm
                 key: retailapp.ack-db-instance01-port
          - name: DATABASE_USER
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_user
          - name: DATABASE_PASSWORD
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_password
          - name: DATABASE_DB_NAME
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_db_name
          - name: DATABASE_RODB_NAME
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: database_rodb_name
          - name: SECRET_KEY
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: secret_key
          - name: AUTHTOKEN
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: authtoken
          - name: MEMDB_HOST
            valueFrom:
              configMapKeyRef:
                 name: memorydb-cluster-conn-cm
                 key: retailapp.memorydb-cluster-host
          - name: MEMDB_PORT
            valueFrom:
              configMapKeyRef:
                 name: memorydb-cluster-conn-cm
                 key: retailapp.memorydb-cluster-port
          - name: MEMDB_USER
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: memdb_user
          - name: MEMDB_PASS
            valueFrom:
              secretKeyRef:
                 name: eksack-secret
                 key: memdb_pass
