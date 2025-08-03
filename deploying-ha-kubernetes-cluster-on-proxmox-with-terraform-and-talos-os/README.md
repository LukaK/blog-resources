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
