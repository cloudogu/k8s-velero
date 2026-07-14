## Vorraussetzungen

- [velero](https://github.com/vmware-tanzu/velero)

## Backup und Restore testen

Testanwendung installieren:
```shell
k apply -f ../samples/testapp/app.yaml
```

Testdaten anlegen:
```shell
kubectl -n csi-app exec -ti csi-nginx -- bash -c 'echo -n "FOOBARBAZ" >> /mnt/longhorndisk/foobar'
```

Backup erstellen:
```shell
velero backup create csi-b1 --include-namespaces csi-app --wait
```

Fehlerfall simulieren:
```shell
k delete ns csi-app
```

Backup einspielen:
```shell
velero restore create --from-backup csi-b1 --wait
```