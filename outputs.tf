
output "vm_id" {
  description = "The ID of the created VM"
  value       = proxmox_virtual_environment_vm.vm.id
}

output "vm_name" {
  description = "The name of the created VM"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "vm_ipv4_address" {
  description = "Instance IPv4 address"
  value       = proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0]
}

# output "vm_ipv6_addresses" {
#   description = "The IPv6 addresses of the VM"
#   value       = proxmox_virtual_environment_vm.vm.ipv6_addresses
# }

# output "vm_mac_addresses" {
#   description = "The MAC addresses of the VM"
#   value       = proxmox_virtual_environment_vm.vm.mac_addresses
# }






