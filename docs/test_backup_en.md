## Requirements

- [velero](https://github.com/vmware-tanzu/velero)

## Test Backup and Restore

Install test application:
```shell
k apply -f testapp/app.yaml
```

Write test data:
```shell
kubectl -n csi-app exec -ti csi-nginx -- bash -c 'echo -n "FOOBARBAZ" >> /mnt/longhorndisk/foobar'
```

Do a backup:
```shell
velero backup create csi-b1 --include-namespaces csi-app --wait
```

Simulate disaster:
```shell
k delete ns csi-app
```

Apply backup:
```shell
velero restore create --from-backup csi-b1 --wait
```