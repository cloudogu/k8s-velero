# Ressourcen im Restore-Prozess ausschließen

Für den Restore-Provider `velero` existiert ein
[Plugin zum Ausschließen von Ressourcen aus dem Backup](https://github.com/cloudogu/velero-plugin-for-restore-exclude/).
Dieses Plugin kann mit `velero` im Cluster angewendet und mit dem Attribute `excludedFromRestores` konfiguriert werden. 
Dabei können Ressourcen mithilfe des GVKN-Patterns aus dem Restore ausgeschlossen werden.
Ressourcen, die hier ausgeschlossen werden und in dem Backup, das eingespielt werden soll, vorhanden sind, werden bei diesem Restore ignoriert.
