ARTIFACT_ID=k8s-velero
VERSION=10.0.1-4
MAKEFILES_VERSION=10.2.0
REGISTRY_NAMESPACE?=k8s
HELM_REPO_ENDPOINT=k3ces.local:30099

include build/make/variables.mk
include build/make/clean.mk
include build/make/self-update.mk

##@ Release
include build/make/k8s-component.mk

.PHONY: velero-release
velero-release: ## Interactively starts the release workflow.
	@echo "Starting git flow release..."
	@build/make/release.sh velero

