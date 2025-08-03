# Deploying highly available cluster on proxmox

Blog post: HERE

## Provision infrastructure

```bash
pushd terraform
terraform plan -var-file=values.tfvars -out create-plan && terraform apply create-plan
popd
```

## Install talos

Update variable values in `ansible/install.yaml`.

```bash
pushd ansible
ansible-playbook install.yaml
popd
```

## Cleanup
```bash
pushd terraform
terraform plan --var-file=values.tfvars --destroy --out destroy-plan && terraform apply destroy-plan
popd
```

## Example

```bash
# deploy example pods
kubectl apply -f examples/pod.yaml

# see ip addresses
kubectl describe pod -n kube-system sample-pod

# see network interfaces
kubectl exec -n kube-system -it sample-pod -- /bin/sh
ip a
```
