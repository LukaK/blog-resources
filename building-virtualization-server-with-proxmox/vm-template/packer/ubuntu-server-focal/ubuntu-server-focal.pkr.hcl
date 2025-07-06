# Ubuntu Server Focal
# ---
# Packer Template to create an Ubuntu Server (Focal) on Proxmox

packer {
  required_plugins {
    proxmox-iso = {
       version = ">= 1.1.7"
      source = "github.com/hashicorp/proxmox"
    }
  }
}


# Resource Definiation for the VM Template
source "proxmox-iso" "ubuntu-server-focal" {

    # proxmox connection settings
    proxmox_url = "${var.proxmox_api_url}"
    username = "${var.proxmox_api_token_id}"
    token = "${var.proxmox_api_token_secret}"
    insecure_skip_tls_verify = false

    # vm fixed general settings
    vm_name = "ubuntu-server-focal"
    template_description = "Ubuntu Server Focal Image"

    # iso file configuration
    iso_file = "${var.iso_file_storage}:${var.iso_file}"
    iso_storage_pool = "${var.iso_storage_pool}"
    unmount_iso = true

    # vm system settings
    qemu_agent = true

    # hard disc settings

    # qcow2 issues: https://github.com/hashicorp/packer-plugin-proxmox/issues/92
    scsi_controller = "virtio-scsi-pci"
    disks {
        disk_size = "${var.disc_size}"
        # format = "qcow2"
        format = "raw"
        storage_pool = "local-lvm"
        type = "virtio"
    }

    # system configuration
    cores = "${var.cpu}"
    memory = "${var.memory}"

    # network settings
    network_adapters {
        model = "${var.network_model}"
        bridge = "${var.network_bridge}"
        firewall = "false"
        vlan_tag = "${var.network_vlan_tag}"
    }

    # cloud init settings
    cloud_init = true
    cloud_init_storage_pool = "local-lvm"

    # packer boot commands
    boot_command = [
        "<esc><wait><esc><wait>",
        "<f6><wait><esc><wait>",
        "<bs><bs><bs><bs><bs>",
        "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
        "--- <enter>"
    ]
    boot = "c"
    boot_wait = "5s"

    # packer auto install settings
    http_directory = "http"
    http_bind_address = "0.0.0.0"
    http_port_min = 8800
    http_port_max = 9000

    ssh_username = "${var.ssh_username}"
    ssh_private_key_file = "${var.ssh_private_key_file}"

    # timeout settings
    ssh_timeout = "40m"
}

build {

    name = "ubuntu-server-focal"

    # add source for every proxmox node
    dynamic "source" {
        for_each = var.vm_configuration
        labels = ["proxmox-iso.ubuntu-server-focal"]

        content {
            node = source.value.node_name
            vm_id = source.value.vm_id
        }
    }

    # provision vm template for cloud init integration in proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo sync"
        ]
    }

    # provision vm template for cloud init integration in proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }

    # provision vm template for cloud init integration in proxmox #3
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }
}
