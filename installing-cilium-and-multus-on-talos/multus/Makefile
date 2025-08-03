
.PHONY: all build show_versions

all: build
build:
	curl https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset-thick.yml -o ./kustomize/00-multus-daemonset-thick.yaml
	cd kustomize && kubectl kustomize . -o ../manifests/00-multus-daemonset-thick.yaml
