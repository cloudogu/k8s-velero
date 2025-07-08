# Exclude files in the restore process

A [plugin for excluding resources from the backup](https://github.com/cloudogu/velero-plugin-for-restore-exclude/) exists for the restore provider `velero`.
This plugin can be used with `velero` in the cluster and configured with the attribute `excludedFromRestores`.
Resources can be excluded from the restore using the GVKN pattern.
Resources that are excluded here and are present in the backup that is to be imported are ignored during this restore.