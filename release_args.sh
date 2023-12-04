#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

componentTemplateFile=k8s/helm/component-patch-tpl.yaml
veleroTempChart="/tmp/velero"
veleroTempValues="${veleroTempChart}/values.yaml"
values="k8s/helm/values.yaml"

# this function will be sourced from release.sh and be called from release_functions.sh
update_versions_modify_files() {
  echo "Update helm dependencies"
  make helm-update-dependencies  > /dev/null

  # Extract longhorn chart
  local veleroVersion
  veleroVersion=$(yq '.dependencies[] | select(.name="velero").version' < "k8s/helm/Chart.yaml")
  local veleroPackage
  veleroPackage="k8s/helm/charts/velero-${veleroVersion}.tgz"

  echo "Extract velero helm chart"
  tar -zxvf "${veleroPackage}" -C "/tmp" > /dev/null

  echo "Set images in component path template"
  update_component_patch_template ".values.images.velero" ".image" "${veleroTempValues}"
  update_component_patch_template ".values.images.kubectl" ".velero.kubectl.image" "${values}"

  local awsPluginImage
  awsPluginImage=$(yq '.velero.initContainers[] | select(.name=="velero-plugin-for-aws").image' < "${values}")
  setAttributeInComponentPatchTemplate ".values.images.awsPlugin" "${awsPluginImage}"
  local csiPluginImage
  csiPluginImage=$(yq '.velero.initContainers[] | select(.name=="velero-plugin-for-csi").image' < "${values}")
  setAttributeInComponentPatchTemplate ".values.images.csiPlugin" "${csiPluginImage}"

  rm -rf ${veleroTempChart}
}

update_component_patch_template() {
  local componentTemplateKey="${1}"
  local dependencyValuesKey="${2}"
  local valuesFile="${3}"

  local repository
  repository=$(yq "${dependencyValuesKey}.repository" < "${valuesFile}")
  local tag
  tag=$(yq "${dependencyValuesKey}.tag" < "${valuesFile}")

  setAttributeInComponentPatchTemplate "${componentTemplateKey}" "${repository}:${tag}"
}

setAttributeInComponentPatchTemplate() {
  local key="${1}"
  local value="${2}"

  yq -i "${key} = \"${value}\"" "${componentTemplateFile}"
}

update_versions_stage_modified_files() {
  git add "${componentTemplateFile}"
}

update_versions_modify_files
