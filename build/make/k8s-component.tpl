# Use the property .spec.deployNamespace to define the namespace the component should be deployed to.
# Make environment variable 'COMPONENT_DEPLOY_NAMESPACE' is responsible for that.
# If 'COMPONENT_DEPLOY_NAMESPACE' is empty the property 'deployNamespace' will be deleted.
apiVersion: k8s.cloudogu.com/v1
kind: Component
metadata:
  name: NAME
  labels:
    app: ces
spec:
  name: NAME
  namespace: NAMESPACE
  version: VERSION
  valuesYamlOverwrite: |
    velero:
      credentials:
        useSecret: true
        existingSecret: velero-backup-target
      configuration:
        backupStorageLocation:
        - name: default
          provider: aws
          bucket: velero
          accessMode: ReadWrite
          config:
            region: minio-default
            s3ForcePathStyle: true
            s3Url: https://9000--main--minio--jweber.coder.cloudogu.com
            publicUrl: https://9000--main--minio--jweber.coder.cloudogu.com