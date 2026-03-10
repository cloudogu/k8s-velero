# This image will be used in the velero helm chart as initcontainer in the upgrade crds job.
# Why? The default image bitnamylegacy contains CVEs and is no longer maintained.
# Unfortunately there is no public image that can be used. Velero needs kubectl and sh (glibc) binaries.
# This image should be tagged as docker.io/cloudogu/k8s-velero-kubectl:<kubectl_version>

# Use 1.36 because velero does not support newer glibc versions.
FROM busybox:1.36.0-glibc

ADD https://dl.k8s.io/release/v1.35.2/bin/linux/amd64/kubectl /usr/local/bin/

# Delete sh and copy from /bin/busybox to create /bin/sh binary as a non-symbolic link
RUN chmod +x /usr/local/bin/kubectl && \
    mkdir -p /tmp && \
    chmod 1777 /tmp && \
    rm /bin/sh && \
    cp /bin/busybox /bin/sh