```apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: dbeaver
  namespace: db-ui
spec:
  selector:
    matchLabels:
      app: dbeaver
      tier: ui
  serviceName: "dbeaver"
  replicas: 1 
  template:
    metadata:
      labels:
        app: dbeaver
        tier: ui
    spec:
      terminationGracePeriodSeconds: 10
      containers:
        - name: dbeaver
          image: dbeaver/cloudbeaver
          ports:
            - containerPort: 8978
              name: http
          env:
            - name: CB_DB_HOST
              value: your_database_host
            - name: CB_DB_PORT
              value: your_database_port
            - name: CB_DB_NAME
              value: your_database_name
            - name: CB_DB_USER
              value: your_database_user
            - name: CB_DB_PASSWORD
              value: your_database_password
          volumeMounts:
            - name: dbeaver-volume
              mountPath: /opt/cloudbeaver/workspace
  volumeClaimTemplates:
    - metadata:
        name: dbeaver-volume
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: ebs-sc
        volumeMode: Filesystem
        resources:
          requests:
            storage: 1Gi
```
