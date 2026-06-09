terraform {
  required_version = ">=1.5.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.99.0"
    }
  }
}

resource "proxmox_cloned_vm" "cloned_vm" {
  name        = var.vm_name
  description = var.vm_description
  tags        = var.vm_tags
  node_name   = var.pve_node_name
  id          = var.vm_id

  clone = {
    source_vm_id     = var.source_vm_id
    source_node_name = var.source_node_name
    full             = var.full_clone
    target_datastore = var.target_datastore
  }

  cpu = {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    # architecture = "x86_64"
    type = var.cpu_type
  }

  memory = {
    size    = var.memory_size
    balloon = var.memory_ballooned
  }

  disk = {
    scsi0 = {
      datastore_id = var.disk_datastore_id
      interface    = var.disk_interface
      ssd          = var.disk_ssd
      discard      = var.disk_discard
      iothread     = var.disk_iothread
      size_gb      = var.disk_size_gb
      cache        = var.disk_cache
    }
  }

  # Lifecycle options
  stop_on_destroy                      = false
  purge_on_destroy                     = true
  delete_unreferenced_disks_on_destroy = true

  timeouts = {
    create = "30m"
    update = "30m"
    delete = "10m"
  }

  network = {
    net0 = {
      bridge   = var.network_bridge
      model    = var.network_model
      tag      = var.vlan_tag
      firewall = var.firewall_enabled
    }
  }
}



