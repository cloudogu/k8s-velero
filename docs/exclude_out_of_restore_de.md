# Ressourcen im Restore-Prozess ausschließen

Für den Restore-Provider `velero` existiert ein
[Plugin zum Ausschließen von Ressourcen aus dem Backup](https://github.com/cloudogu/velero-plugin-for-restore-exclude/).
Dieses Plugin kann mit `velero` im Cluster angewendet und mit dem Attribute `excludedFromRestores` konfiguriert werden. 
Dabei können Ressourcen mithilfe des GVKN-Patterns aus dem Restore ausgeschlossen werden.
Ressourcen, die hier ausgeschlossen werden und in dem Backup, das eingespielt werden soll, vorhanden sind, werden bei diesem Restore ignoriert.

Ein Beispiel einer ConfigMap zum Konfigurieren des Plugins ist [hier](https://github.com/cloudogu/velero-plugin-for-restore-exclude/blob/develop/samples/velero-config.yaml) zu finden. 
Die ConfigMap muss nicht referenziert werden. Sie muss allerdings den Namen 
`velero-plugin-for-restore-exclude-config` besitzen und es müssen die folgenden Labels definiert werden, damit die 
ConfigMap im Cleanup nicht entfernt wird und `velero` weiß, dass es sich um eine `RestoreItemAction` handelt:

```yaml
labels:
    k8s.cloudogu.com/velero-plugin-for-restore-exclude: RestoreItemAction
    k8s.cloudogu.com/part-of: backup
```