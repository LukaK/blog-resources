# Deploying highly available cluster on proxmox

Blog post: HERE

## Install talos with cilium

Provision infrastructure.

```bash
pushd terraform
terraform plan -var-file=values.tfvars -out create-plan && terraform apply create-plan
popd
```


Create cilium manifest file.

```bash
pushd cilium && make && popd
```


Add cilium to talos config.

```yaml
# ./talos/patches/control-cilium.yaml
---
cluster:
  inlineManifests:
    - name: cilium
      contents: |
        ---
        # Source: cilium/templates/cilium-secrets-namespace.yaml
        apiVersion: v1
        kind: Namespace
...
```


Update variable values in `ansible/install.yaml` and install talos cluster.

```bash
pushd ansible
ansible-playbook install.yaml
popd
```

Install multus.
```bash
pushd multus
make
kubectl apply -f manifests
popd
```

## Cleanup
```bash
pushd terraform
terraform plan --var-file=values.tfvars --destroy --out destroy-plan && terraform apply destroy-plan
popd
```
