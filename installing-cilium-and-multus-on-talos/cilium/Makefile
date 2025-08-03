.PHONY: all build show_versions

# CHART_VERSION = 1.15.6
CHART_VERSION = 1.17.6
NAMESPACE = kube-system
REPOSITORY = https://helm.cilium.io/
REPOSITORY_NAME = cilium
CHART_NAME = cilium


all: build
build:
	helm template $(CHART_NAME) \
		--repo $(REPOSITORY)\
		--version $(CHART_VERSION) \
		--namespace $(NAMESPACE) \
		--release-name $(CHART_NAME) \
		--include-crds \
		--values values.yaml > cilium-$(CHART_VERSION).yaml
