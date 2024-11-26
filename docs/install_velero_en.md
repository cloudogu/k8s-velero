# Installing Velero in the local cluster

In order to install Velero in the local k8s cluster, the Helm chart must be installed first.
To do this, execute the following command: `cd k8s/helm/templates && helm dependency update`.
The component can then be installed as usual with `make component-apply`.