# Exclude resources in the restore process

A [plugin for excluding resources from the backup](https://github.com/cloudogu/velero-plugin-for-restore-exclude/) exists for the restore provider `velero`.
This plugin can be used with `velero` in the cluster and configured with the attribute `excludedFromRestores`.
Resources can be excluded from the restore using the GVKN pattern.
Resources that are excluded here and are present in the backup that is to be imported are ignored during this restore.

An example of a ConfigMap for configuring the plugin can be found [here](https://github.com/cloudogu/velero-plugin-for-restore-exclude/blob/develop/samples/velero-config.yaml).
The ConfigMap does not have to be referenced. However, it must have the name
`velero-plugin-for-restore-exclude-config` and the following labels must be defined so that the
ConfigMap is not removed in the cleanup and `velero` knows that it is a `RestoreItemAction`:

```yaml
labels:
    k8s.cloudogu.com/velero-plugin-for-restore-exclude: RestoreItemAction
    k8s.cloudogu.com/part-of: backup
```