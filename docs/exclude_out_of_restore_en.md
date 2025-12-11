# Exclude resources in the restore process

A [plugin for excluding resources from the backup](https://github.com/cloudogu/velero-plugin-for-restore-exclude/) exists for the restore provider `velero`.
Resources can be excluded from the restore using the GVKN pattern.
Resources that are excluded here and are present in the backup that is to be imported are ignored during this restore.

The plugin can be added to velero as an init-container via the Helm-values:
```yaml
velero:
  initContainers:
   - name: velero-plugin-for-restore-exclude
     image: cloudogu/velero-plugin-for-restore-exclude:1.0.0
     imagePullPolicy: IfNotPresent
     volumeMounts:
       - mountPath: /target
         name: plugins
```
Please make sure not to overwrite other necessary init-containers.

An example of a ConfigMap for configuring the plugin can be found [here](https://github.com/cloudogu/velero-plugin-for-restore-exclude/blob/develop/samples/velero-config.yaml).
The ConfigMap does not have to be referenced. However, it must have the name
`velero-plugin-for-restore-exclude-config` and the following labels must be defined so that the
ConfigMap is not removed in the cleanup and `velero` knows that it is a `RestoreItemAction`:

```yaml
labels:
    k8s.cloudogu.com/velero-plugin-for-restore-exclude: RestoreItemAction
```