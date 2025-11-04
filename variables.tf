### VM Basic Configuration
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the virtual machine"
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "Tags to assign to the virtual machine"
  type        = list(string)
  default     = []
}

variable "pve_node_name" {
  type        = string
  description = "Name of the Proxmox node to create the VM on"
  default     = "pve"
}

variable "vm_id" {
  description = "VM ID (automatically assigned if not specified)"
  type        = number
  default     = null
}

variable "bios" {
  description = "BIOS type, setting to `ovmf` will automatically create a EFI disk."
  type        = string
  default     = "seabios"
  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "Invalid bios setting: ${var.bios}. Valid options: 'seabios' or 'ovmf'."
  }
}

variable "on_boot" {
  description = "Start VM on Proxmox host boot."
  type        = bool
  default     = false
}

variable "os_type" {
  description = "Guest operating system type"
  type        = string
  default     = "l26"
}

### Clone Configuration
variable "template_node" {
  description = "Name of Proxmox node where the template resides"
  type        = string
  default     = null # same node as the target node `var.pve_node_name` above
}

variable "template_vm_id" {
  description = "VM ID of the template to clone from"
  type        = number
  default     = null
}

variable "full_clone" {
  description = "Whether to perform a full clone of the template"
  type        = bool
  default     = true
}

### QEMU Guest Agent
variable "qemu_guest_agent" {
  description = "Enable QEMU guest agent."
  type        = bool
  default     = true
}

### CPU Configuration
variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "cpu_sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "CPU type"
  type        = string
  default     = "host"
}

### Memory Configuration
variable "memory_dedicated" {
  description = "Dedicated memory in MB"
  type        = number
  default     = 2048
}

variable "memory_floating" {
  description = "Minimum memory size in `MiB`, setting this value enables memory ballooning."
  type        = number
  default     = 2048
}

### Disk Configuration
variable "scsi_hardware" {
  description = "Storage controller, e.g. `virtio-scsi-pci`."
  type        = string
  default     = "virtio-scsi-single"
}

variable "disks" {
  description = "List of disk configurations."
  type = list(object({
    datastore_id = optional(string, "local-lvm")
    interface    = optional(string, "scsi0")
    ssd          = optional(bool, true)
    discard      = optional(string, "on")
    iothread     = optional(bool, true)
    size         = optional(number, 32)
  }))


  default = [{
    datastore_id = "local-lvm"
    interface    = "scsi0"
    ssd          = true
    discard      = "on"
    iothread     = true
    size         = 32
  }]
}

### EFI Disk Configuration
variable "efi_datastore_id" {
  description = "EFI disk storage location."
  type        = string
  default     = "local-lvm"
}

variable "efi_disk_type" {
  description = "EFI disk OVMF firmware version."
  type        = string
  default     = "4m"
}

variable "efi_pre_enrolled_keys" {
  description = "Use pre-enrolled keys for Secure Boot"
  type        = bool
  default     = false
}

### Cloud-init Variables
variable "ci_datastore_id" {
  description = "Datastore ID for cloud-init disk."
  type        = string
  default     = "local-lvm"
}

variable "ci_dns_domain" {
  description = "DNS domain name. Default `null` value will use PVE host settings."
  type        = string
  default     = null
}

variable "ci_dns_servers" {
  description = "DNS servers. Default `null` value will use PVE host settings."
  type        = list(string)
  default     = ["8.8.8.8"]
}

variable "ci_ipv4_cidr" {
  description = "Default uses DHCP, for a static address set CIDR, e.g. `192.168.1.254/24`."
  type        = string
  default     = "dhcp"
}

variable "ci_ipv4_gateway" {
  description = "IPv4 gateway, required if `var.ci_ipv4_cidr` is set to a static address."
  type        = string
  default     = null
}

### Network Variables
variable "vnic_bridge" {
  description = "Networking adapter bridge, e.g. `vmbr0`."
  type        = string
  default     = "vmbr0"
}

variable "vnic_model" {
  description = "Networking adapter model, e.g. `virtio`."
  type        = string
  default     = "virtio"
}

variable "vlan_tag" {
  description = "Networking adapter VLAN tag."
  type        = number
  default     = null
}

variable "firewall_enabled" {
  description = "Enable Proxmox firewall for this VM."
  type        = bool
  default     = false
}
