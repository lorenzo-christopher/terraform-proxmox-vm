# Proxmox VM Terraform Module

Terraform Proxmox module for provisioning Virtual Machines.

## Quick Start

### 1. Configure Provider

Create an API token in Proxmox:

- Datacenter → Permissions → API Tokens → Add
- User: `root@pam` (or your user)
- Token ID: `terraform`

```hcl
provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = "${var.pve_api_token_id}=${var.pve_api_token_secret}"
  insecure  = var.pve_insecure
  tmp_dir   = "/var/tmp"

  ssh {
    agent    = true
    username = var.pve_ssh_username
  }
}
```

### 2. Deploy a VM

```hcl
module "proxmox_vm" {
  source = "github.com/lorenzo-christopher/terraform-proxmox-vm"

  vm_name          = "example-vm"
  description      = "Demo VM"
  tags             = ["terraform", "proxmox"]
  pve_node_name    = "pve01"
  vm_id            = 110
  template_vm_id   = 9000
  cpu_cores        = 2
  memory_dedicated = 2048
  memory_floating  = 0
  bios             = "seabios"
  on_boot          = true  

  disks = [
    {
      datastore_id = "local-lvm"
      interface    = "scsi0"
      size         = 32
    }
  ]

  ci_datastore_id   = "local-lvm"
  ci_dns_domain     = "example.local"
  ci_dns_servers    = ["8.8.8.8", "1.1.1.1"]
  ci_ipv4_cidr      = "192.168.10.100/24"
  ci_ipv4_gateway   = "192.168.10.1"
  vlan_tag          = 10
}
```

### 3. Apply

```bash
terraform init
terraform plan
terraform apply
```

## Common Configurations

### DHCP Instead of Static IP

```hcl
ci_ipv4_cidr = "dhcp"
```

### Multiple Disks

```hcl
disks = [
  {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 32
  },
  {
    datastore_id = "local-lvm"
    interface    = "scsi1"
    size         = 128
  }
]
```

### UEFI Boot

```hcl
bios = "ovmf"
```

## Outputs

Access VM information after deployment:

```hcl
output "ip_address" {
  value = module.vm.vm_ipv4_addresses
}
```

Available outputs:

- `vm_id` - VM ID number
- `vm_name` - VM name
- `vm_ipv4_addresses` - IPv4 addresses

## Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `vm_name` | VM name | `"web-server"` |
| `pve_node_name` | Proxmox node | `"pve"` |
| `template_vm_id` | Template ID | `9000` |
| `template_node` | Template node | `"pve"` |
