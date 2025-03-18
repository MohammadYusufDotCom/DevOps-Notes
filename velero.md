## install velero 
```
velero install --provider aws --plugins velero/velero-plugin-for-aws:v1.10.0 --bucket lla-data-backup-prod --backup-location-config region=us-east-1 --use-volume-snapshots=false --no-secret

```
