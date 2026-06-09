### VM Basic Configuration
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = null
}

variable "vm_description" {
  description = "Description of the virtual machine"
  type        = string
  default     = "Managed by Terraform"
}

variable "vm_tags" {
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
  description = "VM ID (should automatically assigned if not specified)"
  type        = number
  default     = null
}

### Clone Configuration
variable "source_vm_id" {
  description = "ID of the source VM to clone from"
  type        = number
  default     = null
}

variable "source_node_name" {
  description = "Name of the Proxmox node where the source VM is located (defaults to target node if omitted)"
  type        = string
  default     = null
}

variable "full_clone" {
  description = "Whether to perform a full clone (true) or linked clone (false)"
  type        = bool
  default     = true
}

variable "target_datastore" {
  description = "Datastore ID to use for the cloned VM"
  type        = string
  default     = null
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
variable "memory_size" {
  description = "Total memory available to VM (in MB)"
  type        = number
  default     = 2048
}

variable "memory_ballooned" {
  description = "Minimum guaranteed memory via balloon device (in MB)"
  type        = number
  default     = 2048
}

### Disk Configuration
variable "disk_datastore_id" {
  description = "Datastore ID for the primary disk."
  type        = string
  default     = "local-lvm"
}

variable "disk_interface" {
  description = "Disk interface type (e.g., scsi, sata, virtio)"
  type        = string
  default     = "scsi0"
}

variable "disk_ssd" {
  description = "Whether the disk is on an SSD datastore (true/false)"
  type        = bool
  default     = true
}

variable "disk_discard" {
  description = "Whether to enable discard/TRIM support for the disk (true/false)"
  type        = bool
  default     = true
}

variable "disk_iothread" {
  description = "Whether to enable IOThread for the disk (true/false)"
  type        = bool
  default     = true
}

variable "disk_size_gb" {
  description = "Size of the disk in GB"
  type        = number
  default     = 32
}

variable "disk_cache" {
  description = "Disk cache"
  type        = string
  default     = "writethrough"
}

### Network Variables
variable "network_bridge" {
  description = "Networking adapter bridge, e.g. `vmbr0`."
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
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
