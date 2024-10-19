# How to attach EFS volume to EKS pod 

## Step 1: need to create EFS volume on aws console and copy the file ssystem id
```t
# in our case this is fs-00250b9e8fc26e750 we have mention in pv

```
## Step 2: Attach the EFS IAM policy to EKS node group role
```
# below is the amazon managed policy
AmazonEFSCSIDriverPolicy
```
## step 3: Install the EFS SCI driver from aws add-on (EKS aws console)

## step 4: Aplly the following menifest

### Storage class for EFS
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: efs-sc
provisioner: efs.csi.aws.com
reclaimPolicy: Delete
volumeBindingMode: Immediate

```

### Persist volume claim for EFS
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

### persist volume menefest for EFS

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
