terraform {
  required_version = ">=1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.99.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm_name
  description = var.description
  tags        = var.tags
  node_name   = var.pve_node_name
  vm_id       = var.vm_id
  bios        = var.bios
  on_boot     = var.on_boot

  operating_system {
    type = var.os_type
  }

  clone {
    node_name = var.template_node
    vm_id     = var.template_vm_id
    full      = var.full_clone
    retries   = var.clone_retries
  }

  agent {
    enabled = var.qemu_guest_agent
    wait_for_ip {
      enabled = var.qemu_guest_agent_wait_for_ip
    }
  }

  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.memory_dedicated
    floating  = var.memory_floating
  }

  scsi_hardware = var.scsi_hardware

  dynamic "disk" {
    for_each = var.disks
    content {
      datastore_id = disk.value.datastore_id
      interface    = disk.value.interface
      ssd          = disk.value.ssd
      discard      = disk.value.discard
      iothread     = disk.value.iothread
      size         = disk.value.size
    }
  }

  dynamic "efi_disk" {
    for_each = (var.bios == "ovmf" ? [1] : [])
    content {
      datastore_id      = var.efi_datastore_id
      type              = var.efi_disk_type
      pre_enrolled_keys = var.efi_pre_enrolled_keys
    }
  }

  initialization {
    datastore_id = var.ci_datastore_id

    dns {
      domain  = var.ci_dns_domain
      servers = var.ci_dns_servers
    }

    ip_config {
      ipv4 {
        address = var.ci_ipv4_cidr
        gateway = var.ci_ipv4_gateway
      }
    }


    # dynamic "ip_config" {
    #   for_each = var.ci_ipv4_cidr != "" ? [1] : []
    #   content {
    #     ipv4 {
    #       address = var.ci_ipv4_cidr
    #       gateway = var.ci_ipv4_gateway
    #     }
    #   }
    # }
  }

  # network_device {
  #   bridge   = var.vnic_bridge
  #   model    = var.vnic_model
  #   vlan_id  = var.vlan_tag
  #   firewall = var.firewall_enabled
  # }


  dynamic "network_device" {
    for_each = var.network_devices
    content {
      bridge   = network_device.value.bridge
      model    = network_device.value.model
      vlan_id  = network_device.value.vlan_id
      firewall = network_device.value.firewall
    }
  }
}

