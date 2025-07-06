# iso file storage
iso_file_storage = "backups"

# network configuration
network_vlan_tag = "VLAN TAG"

# ssh access
ssh_username = "ansible"
ssh_private_key_file = "~/.ssh/ansible/id_rsa"

# configuration for proxmox nodes
vm_configuration = [
    {
        node_name = "NODE NAME"
        vm_id = "VM ID"
    },
]
