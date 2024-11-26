# Installation von Velero im lokalen cluster

Damit Velero im lokalen k8s-cluster installiert werden kann, muss vorher das Helm-chart installiert werden.
Dafür folgenden Befehl ausführen: `k8s/helm/templates && helm dependency update`.
Anschließend kann die Komponente wie gewohnt mit `make component-apply` installiert werden.