# Ressourcen im Restore-Prozess ausschließen

Für den Restore-Provider `velero` existiert ein
[Plugin zum Ausschließen von Ressourcen aus dem Backup](https://github.com/cloudogu/velero-plugin-for-restore-exclude/).
Dabei können Ressourcen mithilfe des GVKN-Patterns aus dem Restore ausgeschlossen werden.
Ressourcen, die hier ausgeschlossen werden und in dem Backup, das eingespielt werden soll, vorhanden sind, werden bei diesem Restore ignoriert.

Das Plugin kann als Init-Container über die Helm-Values zu Velero hinzugefügt werden:
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
Dabei darauf achten, dass andere benötigte Init-Container nicht überschrieben werden.

Ein Beispiel einer ConfigMap zum Konfigurieren des Plugins ist [hier](https://github.com/cloudogu/velero-plugin-for-restore-exclude/blob/develop/samples/velero-config.yaml) zu finden. 
Die ConfigMap muss nicht referenziert werden. Sie muss allerdings den Namen 
`velero-plugin-for-restore-exclude-config` besitzen und es müssen die folgenden Labels definiert werden, damit die 
ConfigMap im Cleanup nicht entfernt wird und `velero` weiß, dass es sich um eine `RestoreItemAction` handelt:

```yaml
labels:
    k8s.cloudogu.com/velero-plugin-for-restore-exclude: RestoreItemAction
```