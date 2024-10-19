## Storage class for EFS
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: efs-sc
provisioner: efs.csi.aws.com
reclaimPolicy: Delete
volumeBindingMode: Immediate

```

## Persist volume claim for EFS
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: content-data
  namespace: production
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 20Gi
  volumeName: content-data
  storageClassName: efs-sc
  volumeMode: Filesystem

```

## persist volume menefest for EFS

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: content-data
spec:
  capacity:
    storage: 20Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: efs-sc
  csi:
    driver: efs.csi.aws.com
    volumeHandle: fs-00250b9e8fc26e750
  claimRef:
    kind: PersistentVolumeClaim
    namespace: production
    name: content-data
```
