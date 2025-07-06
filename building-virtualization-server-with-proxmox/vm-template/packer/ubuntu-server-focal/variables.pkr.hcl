# TODO: Add reges
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
    sensitive = true
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "iso_file" {
    type = string
}

variable "iso_file_storage" {
    type = string
}

variable "iso_storage_pool" {
    type = string
    default = "local"
}

variable "disc_size" {
    type = string
    default = "20G"
}

variable "cpu" {
    type = string
    default = "1"
}

variable "memory" {
    type = string
    default = "1024"
}

variable "network_model" {
    type = string
    default = "virtio"
}

variable "network_bridge" {
    type = string
    default = "vmbr0"
}

variable "network_vlan_tag" {
    type = string
}

variable "ssh_username" {
    type = string
}

variable "ssh_private_key_file" {
    type = string
}

variable "vm_configuration" {
    type = list(object({
        node_name = string
        vm_id = string
    }))
}
