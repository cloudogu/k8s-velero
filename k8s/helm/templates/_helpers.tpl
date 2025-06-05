{{- /*
k8s-velero.labels generates Helm labels.
*/ -}}
{{- define "k8s-velero.labels" -}}
app: ces
app.kubernetes.io/name: velero
k8s.cloudogu.com/part-of: backup
{{- end -}}